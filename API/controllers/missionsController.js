const { connectDB, sql } = require('../config/dbConfig');



exports.assignarMissionsDiaries = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const avui = new Date().toISOString().split('T')[0];
    const connection = await connectDB();

    // 0. Comprovar si ja té missions assignades avui (a MISSIONS_DIARIES)
    const [missionsExistents] = await connection.execute(`
      SELECT COUNT(*) AS count
      FROM MISSIONS_DIARIES md
      JOIN USUARIS_MISSIONS um ON md.usuaris_missions_id = um.id
      WHERE um.usuari_id = ? AND DATE(md.data_entry) = ?
    `, [usuariId, avui]);

    if (missionsExistents[0].count === 0) {
      // 1. Assignar missions fixes de tipus 0 (crear relació a USUARIS_MISSIONS si no existeix)
      const [fixes] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = TRUE AND tipus_missio = 0
      `);

      for (const missio of fixes) {
        // Comprovar si ja existeix la relació usuari-missió
        const [relacio] = await connection.execute(`
          SELECT id FROM USUARIS_MISSIONS WHERE usuari_id = ? AND missio_id = ?
        `, [usuariId, missio.id]);

        let usuarisMissionsId;
        if (relacio.length === 0) {
          // Crear la relació
          const [result] = await connection.execute(`
            INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
            VALUES (?, ?)
          `, [usuariId, missio.id]);
          usuarisMissionsId = result.insertId;
        } else {
          usuarisMissionsId = relacio[0].id;
        }

        // Crear una entrada a MISSIONS_DIARIES per avui (progress inicial pot ser 0)
        await connection.execute(`
          INSERT INTO MISSIONS_DIARIES (missio_id, usuaris_missions_id, descripcio, data_entry)
          VALUES (?, ?, NULL, ?)
        `, [missio.id, usuarisMissionsId, avui]);
      }

      // 2. Assignar una variable del dia (rotativa)
      const [variables] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = FALSE AND tipus_missio = 0 ORDER BY id
      `);

      if (variables.length > 0) {
        const dia = new Date();
        const index = dia.getDate() % variables.length;
        const variableDelDia = variables[index];

        // Igual que abans, crear relació si no existeix
        const [relacioVar] = await connection.execute(`
          SELECT id FROM USUARIS_MISSIONS WHERE usuari_id = ? AND missio_id = ?
        `, [usuariId, variableDelDia.id]);

        let usuarisMissionsIdVar;
        if (relacioVar.length === 0) {
          const [resultVar] = await connection.execute(`
            INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
            VALUES (?, ?)
          `, [usuariId, variableDelDia.id]);
          usuarisMissionsIdVar = resultVar.insertId;
        } else {
          usuarisMissionsIdVar = relacioVar[0].id;
        }

        // Assignar la variable del dia a MISSIONS_DIARIES
        await connection.execute(`
          INSERT INTO MISSIONS_DIARIES (missio_id, usuaris_missions_id, descripcio, data_entry)
          VALUES (?, ?, NULL, ?)
        `, [variableDelDia.id, usuarisMissionsIdVar, avui]);
      }
    }

    // 3. Recuperar les missions assignades avui per l’usuari (MISSIONS_DIARIES + MISSIONS)
    const [missionsAssignades] = await connection.execute(`
  SELECT md.id, md.missio_id as missio, md.usuaris_missions_id, md.data_entry as data_assig, m.descripcio, 
         m.nom_missio, m.objectiu, um.progres as progress
  FROM MISSIONS_DIARIES md
  JOIN USUARIS_MISSIONS um ON md.usuaris_missions_id = um.id
  JOIN MISSIONS m ON md.missio_id = m.id
  WHERE um.usuari_id = ? AND DATE(md.data_entry) = ?
  ORDER BY md.missio_id
`, [usuariId, avui]);

const missionsAdaptades = missionsAssignades.map(m => ({
  id: m.id,
  usuari: usuariId,           // usuari
  missio: m.missio,
  data_assig: m.data_assig,   // dataAssign al model, aquí manté aquest nom
  nom_missio: m.nom_missio,   // nom al model, aquí manté aquest nom
  descripcio: m.descripcio,
  progress: m.progress,
  objectiu: m.objectiu,
}));

res.status(200).json({ missatge: 'Missions assignades correctament!', missions: missionsAdaptades });

    console.log(missionsAssignades);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error assignant missions' });
  }
};


exports.incrementarProgresMissio = async (req, res) => {
  const missioDiariaId = parseInt(req.params.id);

  if (!missioDiariaId) {
    return res.status(400).json({ error: 'ID invàlid' });
  }

  let pool;
  let connection;

  try {
    pool = await connectDB();
    connection = await pool.getConnection();

    await connection.beginTransaction();

    // 1. Agafar dades bloquejant fila (FOR UPDATE)
    // Ara md.usuaris_missions_id referencia progress a USUARIS_MISSIONS
    const [rows] = await connection.execute(`
      SELECT um.progres, m.objectiu, um.usuari_id, m.punts
      FROM MISSIONS_DIARIES md
      JOIN USUARIS_MISSIONS um ON md.usuaris_missions_id = um.id
      JOIN MISSIONS m ON um.missio_id = m.id
      WHERE md.id = ?
      FOR UPDATE
    `, [missioDiariaId]);

    if (rows.length === 0) {
      await connection.rollback();
      connection.release();
      return res.status(404).json({ error: 'Missió no trobada' });
    }

    const { progress, objectiu, usuari_id, punts } = rows[0];

    if (progress >= objectiu) {
      await connection.rollback();
      connection.release();
      return res.status(200).json({ missatge: 'Missió ja completada' });
    }

    // 2. Incrementar progress a USUARIS_MISSIONS
    const [result] = await connection.execute(`
      UPDATE USUARIS_MISSIONS
      SET progres = progres + 1
      WHERE id = (
        SELECT usuaris_missions_id FROM MISSIONS_DIARIES WHERE id = ?
      )
    `, [missioDiariaId]);

    if (result.affectedRows === 0) {
      await connection.rollback();
      connection.release();
      return res.status(404).json({ error: 'Missió no trobada' });
    }

    // 3. Si s'ha completat la missió ara, afegir punts a l'usuari
    if (progress + 1 >= objectiu && punts && !isNaN(punts)) {
      await connection.execute(`
        UPDATE USUARIS
        SET punts_emmagatzemats = punts_emmagatzemats + ?
        WHERE id = ?
      `, [punts, usuari_id]);
    }

    await connection.commit();
    connection.release();

    res.status(200).json({ missatge: 'Progrés incrementat correctament' });

  } catch (err) {
    if (connection) {
      await connection.rollback();
      connection.release();
    }
    console.error(err);
    res.status(500).json({ error: 'Error incrementant el progrés de la missió' });
  }
};


exports.assignarMissionsTitols = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const connection = await connectDB();

    // 1. Obtenir títols de l'usuari
    const [titolsUsuari] = await connection.execute(`
      SELECT t.id AS titol_id
      FROM BIBLIOTECA b
      JOIN PERSONATGES p ON b.personatge_id = p.id
      JOIN TITOLS t ON t.personatge = p.id
      WHERE b.user_id = ?
    `, [usuariId]);

    // 2. Obtenir totes les missions de tipus 1 (de títol)
    const [missionsTipus1] = await connection.execute(`
      SELECT id FROM MISSIONS WHERE tipus_missio = 1
    `);

    // 3. Per cada títol i missió, crear un USUARIS_MISSIONS NOU i vincular-lo a MISSIONS_TITOLS
    for (const { titol_id } of titolsUsuari) {
      for (const { id: missio_id } of missionsTipus1) {
        // Crear un nou USUARIS_MISSIONS per aquesta combinació
        const [result] = await connection.execute(`
          INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
          VALUES (?, ?)
        `, [usuariId, missio_id]);

        const usuarisMissionsId = result.insertId;

        // Insertar a MISSIONS_TITOLS
        await connection.execute(`
          INSERT INTO MISSIONS_TITOLS (titol_id, missio_id, usuaris_missions_id)
          VALUES (?, ?, ?)
        `, [titol_id, missio_id, usuarisMissionsId]);
      }
    }

    res.status(200).json({ missatge: 'Missions de títol assignades correctament!' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error assignant missions de títol' });
  }
};



exports.getMissionTitol = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari invàlid' });
  }

  try {
    const connection = await connectDB();

    const [missions] = await connection.execute(`
      SELECT 
        m.id,
        m.nom_missio,
        m.descripcio,
        m.objectiu,
        um.progres,
        t.id AS titol_id,
        t.nom_titol
      FROM MISSIONS_TITOLS mt
      JOIN MISSIONS m ON m.id = mt.missio_id AND m.tipus_missio = 1
      JOIN USUARIS_MISSIONS um ON um.id = mt.usuaris_missions_id AND um.usuari_id = ?
      JOIN TITOLS t ON t.id = mt.titol_id
      JOIN SKINS s ON s.personatge = t.personatge
      JOIN USUARI_SKIN_ARMES usa ON usa.skin = s.id AND usa.usuari = ? AND usa.seleccionat = 1
      LIMIT 1
    `, [usuariId, usuariId]);

    if (missions.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat cap missió associada al títol i skin seleccionada' });
    }

    const missio = missions[0];

    res.status(200).json({
      missatge: 'Missió de títol recuperada correctament',
      titol_id: missio.titol_id,
      nom_titol: missio.nom_titol,
      missio
    });

  } catch (err) {
    console.error('Error al recuperar la missió de títol:', err);
    res.status(500).json({ error: 'Error recuperant la missió de títol' });
  }
};



exports.incrementarProgresTitol = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari ID invàlid' });
  }

  try {
    const connection = await connectDB();

    // 1. Obtenim el títol seleccionat per l'usuari
    const [titolsUsuari] = await connection.execute(`
      SELECT t.id AS titol_id
      FROM USUARI_SKIN_ARMES usa
      JOIN SKINS s ON s.id = usa.skin
      JOIN TITOLS t ON t.personatge = s.personatge
      WHERE usa.usuari = ? AND usa.seleccionat = 1
    `, [usuariId]);

    if (titolsUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat cap títol seleccionat per aquest usuari' });
    }

    const titolId = titolsUsuari[0].titol_id;

    // 2. Obtenim la missió activa de tipus 1 i el seu usuaris_missions_id i progrés
    const [missions] = await connection.execute(`
      SELECT mt.usuaris_missions_id, m.id AS missio_id, um.progres, m.objectiu
      FROM MISSIONS_TITOLS mt
      JOIN MISSIONS m ON m.id = mt.missio_id
      JOIN USUARIS_MISSIONS um ON um.id = mt.usuaris_missions_id
      WHERE mt.titol_id = ? AND um.usuari_id = ? AND m.tipus_missio = 1
      LIMIT 1
    `, [titolId, usuariId]);

    if (missions.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat cap missió de títol per aquest usuari' });
    }

    const { usuaris_missions_id, missio_id, progres, objectiu } = missions[0];

    if (progres >= objectiu) {
      return res.status(200).json({ missatge: 'La missió ja està completada', progres });
    }

    const nouProgres = progres + 1;

    // 3. Actualitzem el progrés a USUARIS_MISSIONS
    await connection.execute(`
      UPDATE USUARIS_MISSIONS
      SET progres = ?
      WHERE id = ?
    `, [nouProgres, usuaris_missions_id]);

    res.status(200).json({ missatge: 'Progrés actualitzat correctament', progres: nouProgres });

  } catch (err) {
    console.error('Error incrementant el progres:', err.message);
    res.status(500).json({ error: 'Error al incrementar el progres de la missió' });
  }
};


exports.assignarMissionsArmes = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const connection = await connectDB();

    // 1. Obtenir biblioteca
    const [biblioteca] = await connection.execute(`
      SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?
    `, [usuariId]);

    if (biblioteca.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat biblioteca per l\'usuari' });
    }

    // 2. Treure skins i convertir a array
    let skinsUsuari = [];
    for (const fila of biblioteca) {
      if (fila.skin_ids) {
        const skinsArray = fila.skin_ids.split(',').map(s => s.trim()).filter(s => s.length > 0);
        skinsUsuari = skinsUsuari.concat(skinsArray);
      }
    }
    skinsUsuari = skinsUsuari.map(Number).filter(n => !isNaN(n));

    if (skinsUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat skins a la biblioteca' });
    }

    // 3. Obtenir armes amb categoria
    const placeholdersSkins = skinsUsuari.map(() => '?').join(',');
    const [armesUsuari] = await connection.execute(`
      SELECT DISTINCT sa.arma, a.categoria
      FROM SKINS_ARMES sa
      JOIN ARMES a ON sa.arma = a.id
      WHERE sa.skin IN (${placeholdersSkins})
    `, skinsUsuari);

    if (armesUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat armes per aquestes skins' });
    }

    // 4. Obtenir les missions per tipus 2, 3 i 4
    const tipusMissio = [2, 3, 4];
    const missions = {};

    for (const tipus of tipusMissio) {
      const [result] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE tipus_missio = ? LIMIT 1
      `, [tipus]);

      if (result.length === 0) {
        return res.status(404).json({ error: `No s'han trobat missions de tipus ${tipus}` });
      }

      missions[tipus] = result[0].id;
    }

    // 5. Assignar missió segons categoria
    for (const { arma, categoria } of armesUsuari) {
      let tipus;

      if (categoria === 0) tipus = 2;
      else if (categoria === 1) tipus = 3;
      else if (categoria === 2) tipus = 4;
      else continue; // Ignorem categories no contemplades

      const missio_id = missions[tipus];

      // **Crear SEMPRE un nou USUARIS_MISSIONS per cada arma i missió**
      const [insertResult] = await connection.execute(`
        INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id, progres)
        VALUES (?, ?, 0)
      `, [usuariId, missio_id]);

      const usuaris_missions_id = insertResult.insertId;

      // Insertar a MISSIONS_ARMES sense comprovar existència (per evitar duplicats pots fer un control addicional si vols)
      await connection.execute(`
        INSERT INTO MISSIONS_ARMES (missio_id, arma_id, usuaris_missions_id)
        VALUES (?, ?, ?)
      `, [missio_id, arma, usuaris_missions_id]);
    }

    res.status(200).json({ missatge: 'Missions d’armes assignades correctament!' });

  } catch (err) {
    console.error('Error assignant missions d’armes:', err);
    res.status(500).json({ error: 'Error assignant missions d’armes' });
  }
};




exports.getMissionArma = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const connection = await connectDB();

    // Consulta que uneix tot per obtenir la primera missió no completada per armes de skins seleccionats,
    // ordenant per la seqüència de tipus de missió que vols
    const [missions] = await connection.execute(`
      SELECT 
        m.id,
        m.nom_missio,
        m.descripcio,
        m.objectiu,
        um.progres,
        a.id AS arma_id,
        a.nom AS nom_arma,
        m.tipus_missio
      FROM USUARI_SKIN_ARMES usa
      JOIN SKINS_ARMES sa ON sa.skin = usa.skin
      JOIN ARMES a ON a.id = sa.arma
      JOIN MISSIONS_ARMES ma ON ma.arma_id = a.id
      JOIN USUARIS_MISSIONS um ON um.id = ma.usuaris_missions_id AND um.usuari_id = usa.usuari
      JOIN MISSIONS m ON m.id = um.missio_id
      WHERE usa.usuari = ? AND usa.seleccionat = 1
      AND um.progres < m.objectiu
      AND m.tipus_missio IN (2,3,4)
      ORDER BY FIELD(m.tipus_missio, 2, 3, 4), um.progres ASC
      LIMIT 1
    `, [usuariId]);

    if (missions.length === 0) {
      return res.status(200).json({ missatge: 'Totes les missions estan completades per totes les armes associades als skins seleccionats' });
    }

    const missioFinal = missions[0];

    res.status(200).json({
      missatge: 'Missió d\'arma recuperada correctament',
      arma: missioFinal.nom_arma,
      missio: {
        id: missioFinal.id,
        nom_missio: missioFinal.nom_missio,
        descripcio: missioFinal.descripcio,
        objectiu: missioFinal.objectiu,
        progres: missioFinal.progres,
        tipus_missio: missioFinal.tipus_missio
      }
    });

  } catch (err) {
    console.error('Error al recuperar la missió d\'arma:', err);
    res.status(500).json({ error: 'Error recuperant la missió d\'arma' });
  }
};







exports.incrementarProgresArma = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari ID invàlid' });
  }

  try {
    const connection = await connectDB();

    // 1. Obtenir els skins seleccionats
    const [skinsSeleccionats] = await connection.execute(`
      SELECT skin
      FROM USUARI_SKIN_ARMES
      WHERE usuari = ? AND seleccionat = 1
    `, [usuariId]);

    if (skinsSeleccionats.length === 0) {
      return res.status(200).json({ missatge: 'L\'usuari no té cap skin seleccionat. No hi ha missions a incrementar.' });
    }

    const skinsIds = skinsSeleccionats.map(s => s.skin);
    const placeholders = skinsIds.map(() => '?').join(',');

    // 2. Obtenir les armes associades
    const [armes] = await connection.execute(`
      SELECT DISTINCT a.id AS arma_id, a.nom AS nom_arma
      FROM SKINS_ARMES sa
      JOIN ARMES a ON sa.arma = a.id
      WHERE sa.skin IN (${placeholders})
    `, skinsIds);

    if (armes.length === 0) {
      return res.status(200).json({ missatge: 'Cap arma trobada per als skins seleccionats. No hi ha missions a incrementar.' });
    }

    let missioActualitzada = null;

    for (const { arma_id: armaId, nom_arma: nomArma } of armes) {
      // 3. Buscar MISSIONS_ARMES per a l’usuari i arma
      const [missioArma] = await connection.execute(`
        SELECT ma.id, ma.missio_id, ma.usuaris_missions_id, um.progres, m.objectiu, m.nom_missio, m.descripcio
        FROM MISSIONS_ARMES ma
        JOIN USUARIS_MISSIONS um ON ma.usuaris_missions_id = um.id
        JOIN MISSIONS m ON ma.missio_id = m.id
        WHERE ma.arma_id = ? AND um.usuari_id = ?
        ORDER BY ma.id
      `, [armaId, usuariId]);

      if (missioArma.length === 0) continue;

      const noCompletada = missioArma.find(m => m.progres < m.objectiu);
      if (noCompletada) {
        const nouProgres = noCompletada.progres + 1;

        // 4. Actualitzar progrés a USUARIS_MISSIONS
        await connection.execute(`
          UPDATE USUARIS_MISSIONS
          SET progres = ?
          WHERE id = ?
        `, [nouProgres, noCompletada.usuaris_missions_id]);

        // 5. Retornar amb l'estructura del nou model
        missioActualitzada = {
          arma: nomArma,
          missio: {
            id: noCompletada.id,
            nom_missio: noCompletada.nom_missio,
            descripcio: noCompletada.descripcio,
            objectiu: noCompletada.objectiu,
            progres: nouProgres
          }
        };
        break;
      }
    }

    if (!missioActualitzada) {
      return res.status(200).json({ missatge: 'Totes les missions estan completades o no hi ha missions disponibles. No hi ha res a incrementar.' });
    }

    res.status(200).json(missioActualitzada);

  } catch (err) {
    console.error('Error incrementant el progrés:', err.message);
    res.status(500).json({ error: 'Error al incrementar el progrés de la missió' });
  }
};











