const { connectDB, sql } = require('../config/dbConfig');



exports.assignarMissionsDiaries = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const avui = new Date().toISOString().split('T')[0];
    const connection = await connectDB();

    // 0. Comprovar si ja té missions assignades avui
    const [missionsExistents] = await connection.execute(`
      SELECT COUNT(*) AS count
      FROM MISSIONS_DIARIES md
      JOIN USUARIS_MISSIONS um ON md.usuaris_missions_id = um.id
      WHERE um.usuari_id = ? AND DATE(md.data_assig) = ?
    `, [usuariId, avui]);

    if (missionsExistents[0].count === 0) {
      // 1. Assignar missions fixes de tipus 0
      const [fixes] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = TRUE AND tipus_missio = 0
      `);

      for (const missio of fixes) {
        // Crear entrada a USUARIS_MISSIONS si no existeix
        const [umExists] = await connection.execute(`
          SELECT id FROM USUARIS_MISSIONS
          WHERE usuari_id = ? AND missio_id = ?
        `, [usuariId, missio.id]);

        let usuarisMissioId;
        if (umExists.length === 0) {
          const [insertResult] = await connection.execute(`
            INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
            VALUES (?, ?)
          `, [usuariId, missio.id]);
          usuarisMissioId = insertResult.insertId;
        } else {
          usuarisMissioId = umExists[0].id;
        }

        // Insertar a MISSIONS_DIARIES
        await connection.execute(`
          INSERT INTO MISSIONS_DIARIES (usuaris_missions_id, data_assig)
          VALUES (?, ?)
        `, [usuarisMissioId, avui]);
      }

      // 2. Assignar una variable del dia (rotativa)
      const [variables] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = FALSE AND tipus_missio = 0 ORDER BY id
      `);

      if (variables.length > 0) {
        const dia = new Date();
        const index = dia.getDate() % variables.length;
        const variableDelDia = variables[index];

        // Crear entrada a USUARIS_MISSIONS per la missió variable
        const [umExistsVar] = await connection.execute(`
          SELECT id FROM USUARIS_MISSIONS
          WHERE usuari_id = ? AND missio_id = ?
        `, [usuariId, variableDelDia.id]);

        let usuarisMissioIdVar;
        if (umExistsVar.length === 0) {
          const [insertResultVar] = await connection.execute(`
            INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
            VALUES (?, ?)
          `, [usuariId, variableDelDia.id]);
          usuarisMissioIdVar = insertResultVar.insertId;
        } else {
          usuarisMissioIdVar = umExistsVar[0].id;
        }

        await connection.execute(`
          INSERT INTO MISSIONS_DIARIES (usuaris_missions_id, data_assig)
          VALUES (?, ?)
        `, [usuarisMissioIdVar, avui]);
      }
    }

    // 3. Recuperar les missions assignades avui per l’usuari
    const [missionsAssignades] = await connection.execute(`
      SELECT md.id, um.usuari_id AS usuari, md.usuaris_missions_id, md.data_assig, md.progress, m.nom_missio, m.descripcio, m.objectiu
      FROM MISSIONS_DIARIES md
      JOIN USUARIS_MISSIONS um ON md.usuaris_missions_id = um.id
      JOIN MISSIONS m ON um.missio_id = m.id
      WHERE um.usuari_id = ? AND DATE(md.data_assig) = ?
      ORDER BY m.id
    `, [usuariId, avui]);

    res.status(200).json({ missatge: 'Missions assignades correctament!', missions: missionsAssignades });

  } catch (err) {
    console.error('Error assignant missions:', err);
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

    // Bloquejar la fila per evitar condicions de carrera
    const [rows] = await connection.execute(`
      SELECT md.progress, m.objectiu, um.usuari_id AS usuari, m.punts
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

    const { progress, objectiu, usuari, punts } = rows[0];

    if (progress >= objectiu) {
      await connection.rollback();
      connection.release();
      return res.status(200).json({ missatge: 'Missió ja completada' });
    }

    const [result] = await connection.execute(`
      UPDATE MISSIONS_DIARIES
      SET progress = progress + 1
      WHERE id = ?
    `, [missioDiariaId]);

    if (result.affectedRows === 0) {
      await connection.rollback();
      connection.release();
      return res.status(404).json({ error: 'Missió no trobada' });
    }

    // Si la missió s'ha completat ara, afegir punts a l'usuari
    if (progress + 1 >= objectiu && punts && !isNaN(punts)) {
      await connection.execute(`
        UPDATE USUARIS
        SET punts_emmagatzemats = punts_emmagatzemats + ?
        WHERE id = ?
      `, [punts, usuari]);
    }

    await connection.commit();
    connection.release();

    res.status(200).json({ missatge: 'Progrés incrementat correctament' });

  } catch (err) {
    if (connection) {
      await connection.rollback();
      connection.release();
    }
    console.error('Error incrementant el progrés de la missió:', err);
    res.status(500).json({ error: 'Error incrementant el progrés de la missió' });
  }
};


exports.assignarMissionsTitols = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const connection = await connectDB();

    // 1. Obtenir tots els títols de l'usuari a partir de la biblioteca i personatges
    const [titolsUsuari] = await connection.execute(`
      SELECT t.id AS titol_id
      FROM BIBLIOTECA b
      JOIN PERSONATGES p ON b.personatge_id = p.id
      JOIN TITOLS t ON t.personatge = p.id
      WHERE b.user_id = ?
    `, [usuariId]);

    if (titolsUsuari.length === 0) {
      return res.status(404).json({ error: 'L\'usuari no té cap títol a la biblioteca' });
    }

    // 2. Obtenir totes les missions de tipus 1 (de títol)
    const [missionsTipus1] = await connection.execute(`
      SELECT id FROM MISSIONS WHERE tipus_missio = 1
    `);

    if (missionsTipus1.length === 0) {
      return res.status(404).json({ error: 'No hi ha missions de tipus títol disponibles' });
    }

    // 3. Per cada missió, verificar o crear l'assignació a USUARIS_MISSIONS
    //    I després, per cada títol, verificar o crear l'entrada a MISSIONS_TITOLS
    for (const { id: missioId } of missionsTipus1) {
      // Comprovar si ja existeix la assignació a USUARIS_MISSIONS per a aquest usuari i missió
      const [usuarisMissionsRows] = await connection.execute(`
        SELECT id FROM USUARIS_MISSIONS
        WHERE usuari_id = ? AND missio_id = ?
      `, [usuariId, missioId]);

      let usuarisMissionsId;
      if (usuarisMissionsRows.length === 0) {
        // Crear la assignació a USUARIS_MISSIONS
        const [result] = await connection.execute(`
          INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id)
          VALUES (?, ?)
        `, [usuariId, missioId]);
        usuarisMissionsId = result.insertId;
      } else {
        usuarisMissionsId = usuarisMissionsRows[0].id;
      }

      // Per cada títol, verificar si ja existeix a MISSIONS_TITOLS
      for (const { titol_id: titolId } of titolsUsuari) {
        const [existeix] = await connection.execute(`
          SELECT 1 FROM MISSIONS_TITOLS
          WHERE usuaris_missions_id = ? AND titol_id = ?
        `, [usuarisMissionsId, titolId]);

        if (existeix.length === 0) {
          await connection.execute(`
            INSERT INTO MISSIONS_TITOLS (usuaris_missions_id, titol_id, progress)
            VALUES (?, ?, 0)
          `, [usuarisMissionsId, titolId]);
        }
      }
    }

    res.status(200).json({ missatge: 'Missions de títol assignades correctament!' });
  } catch (err) {
    console.error('Error assignant missions de títol:', err);
    res.status(500).json({ error: 'Error assignant missions de títol' });
  }
};


exports.getMissionTitol = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    console.warn('Usuari ID invàlid:', req.params.usuariId);
    return res.status(400).json({ error: 'Usuari invàlid' });
  }

  try {
    const connection = await connectDB();

    console.log(`Buscant títol per usuari ${usuariId}`);

    const [titolsUsuari] = await connection.execute(`
      SELECT 
        t.id AS titol_id,
        t.nom_titol
      FROM USUARI_SKIN_ARMES usa
      JOIN SKINS s ON s.id = usa.skin
      JOIN TITOLS t ON t.personatge = s.personatge
      WHERE usa.usuari = ? AND usa.seleccionat = 1
    `, [usuariId]);

    console.log('Resultat titolsUsuari:', titolsUsuari);

    if (titolsUsuari.length === 0) {
      console.warn(`Cap títol trobat per usuari ${usuariId}`);
      return res.status(404).json({ error: 'No s\'ha trobat cap títol del personatge seleccionat per aquest usuari' });
    }

    const { titol_id: titolId, nom_titol: nomTitol } = titolsUsuari[0];

    console.log(`Títol seleccionat: ID=${titolId}, Nom="${nomTitol}"`);

    // Obtenir missions assignades a l'usuari
    const [usuarisMissions] = await connection.execute(`
      SELECT id
      FROM USUARIS_MISSIONS
      WHERE usuari_id = ?
    `, [usuariId]);

    if (usuarisMissions.length === 0) {
      console.warn(`L'usuari ${usuariId} no té missions assignades`);
      return res.status(404).json({ error: 'L\'usuari no té missions assignades' });
    }

    const usuarisMissionsIds = usuarisMissions.map(um => um.id);
    const umPlaceholders = usuarisMissionsIds.map(() => '?').join(',');

    // Obtenir la missió de títol
    const [missions] = await connection.execute(`
      SELECT 
        m.id,
        m.nom_missio,
        m.descripcio,
        m.objectiu,
        mt.progress
      FROM MISSIONS_TITOLS mt
      JOIN USUARIS_MISSIONS um ON mt.usuaris_missions_id = um.id
      JOIN MISSIONS m ON m.id = um.missio_id
      WHERE mt.titol_id = ? AND mt.usuaris_missions_id IN (${umPlaceholders}) AND m.tipus_missio = 1
      LIMIT 1
    `, [titolId, ...usuarisMissionsIds]);

    console.log('Resultat missió:', missions);

    if (missions.length === 0) {
      console.warn(`No s'ha trobat cap missió pel títol ${titolId} i usuari ${usuariId}`);
      return res.status(404).json({ error: 'No s\'ha trobat cap missió associada a aquest títol' });
    }

    const missio = missions[0];

    console.log('Missió retornada:', missio);

    res.status(200).json({
      missatge: 'Missió de títol recuperada correctament',
      titol_id: titolId,
      nom_titol: nomTitol,
      missio
    });

  } catch (err) {
    console.error('Error al recuperar la missió de títol:', err.message);
    console.error(err.stack);
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

    // Obtenim el títol seleccionat per l'usuari
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

    // Obtenim les missions assignades a l'usuari (USUARIS_MISSIONS)
    const [usuarisMissions] = await connection.execute(`
      SELECT id, missio_id
      FROM USUARIS_MISSIONS
      WHERE usuari_id = ?
    `, [usuariId]);

    if (usuarisMissions.length === 0) {
      return res.status(404).json({ error: 'L\'usuari no té missions assignades' });
    }

    const usuarisMissionsIds = usuarisMissions.map(um => um.id);
    const umPlaceholders = usuarisMissionsIds.map(() => '?').join(',');

    // Busquem la missió activa de tipus 1 per aquest títol i usuari
    const [missions] = await connection.execute(`
      SELECT mt.id, mt.progress, m.objectiu, um.missio_id
      FROM MISSIONS_TITOLS mt
      JOIN USUARIS_MISSIONS um ON mt.usuaris_missions_id = um.id
      JOIN MISSIONS m ON m.id = um.missio_id
      WHERE mt.titol_id = ? AND mt.usuaris_missions_id IN (${umPlaceholders}) AND m.tipus_missio = 1
      LIMIT 1
    `, [titolId, ...usuarisMissionsIds]);

    if (missions.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat cap missió de títol per aquest usuari' });
    }

    const { id: mtId, progress, objectiu } = missions[0];

    if (progress >= objectiu) {
      return res.status(200).json({ missatge: 'La missió ja està completada', progress });
    }

    const nouProgres = progress + 1;

    // Actualitzem el progress
    await connection.execute(`
      UPDATE MISSIONS_TITOLS
      SET progress = ?
      WHERE id = ?
    `, [nouProgres, mtId]);

    res.status(200).json({ missatge: 'Progrés actualitzat correctament', progress: nouProgres });

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
    if (skinsUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat skins a la biblioteca' });
    }
    skinsUsuari = skinsUsuari.map(Number).filter(n => !isNaN(n));

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

    // 5. Assignar missió i armes vinculant amb USUARIS_MISSIONS
    for (const { arma, categoria } of armesUsuari) {
      let tipus;

      if (categoria === 0) tipus = 2;
      else if (categoria === 1) tipus = 3;
      else if (categoria === 2) tipus = 4;
      else continue; // Ignorem categories no contemplades

      const missio_id = missions[tipus];

      // Buscar o crear la assignació usuari-missió
      const [usuarisMissions] = await connection.execute(`
        SELECT id FROM USUARIS_MISSIONS WHERE usuari_id = ? AND missio_id = ?
      `, [usuariId, missio_id]);

      let usuarisMissionsId;

      if (usuarisMissions.length === 0) {
        const [insertResult] = await connection.execute(`
          INSERT INTO USUARIS_MISSIONS (usuari_id, missio_id) VALUES (?, ?)
        `, [usuariId, missio_id]);
        usuarisMissionsId = insertResult.insertId;
      } else {
        usuarisMissionsId = usuarisMissions[0].id;
      }

      // Comprovar si ja existeix la arma per a aquesta assignació
      const [existeix] = await connection.execute(`
        SELECT 1 FROM MISSIONS_ARMES WHERE usuaris_missions_id = ? AND arma_id = ?
      `, [usuarisMissionsId, arma]);

      if (existeix.length === 0) {
        await connection.execute(`
          INSERT INTO MISSIONS_ARMES (usuaris_missions_id, arma_id)
          VALUES (?, ?)
        `, [usuarisMissionsId, arma]);
      }
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

    // 1. Obtenir skins seleccionats per l'usuari
    const [skinsSeleccionats] = await connection.execute(`
      SELECT skin
      FROM USUARI_SKIN_ARMES
      WHERE usuari = ? AND seleccionat = 1
    `, [usuariId]);

    if (skinsSeleccionats.length === 0) {
      return res.status(200).json({ missatge: 'L\'usuari no té cap skin seleccionat. No hi ha missions disponibles.' });
    }

    // 2. Obtenir armes associades als skins seleccionats
    const skinsIds = skinsSeleccionats.map(s => s.skin);
    const placeholders = skinsIds.map(() => '?').join(',');
    const [armes] = await connection.execute(`
      SELECT DISTINCT a.id AS arma_id, a.nom AS nom_arma
      FROM SKINS_ARMES sa
      JOIN ARMES a ON sa.arma = a.id
      WHERE sa.skin IN (${placeholders})
    `, skinsIds);

    if (armes.length === 0) {
      return res.status(200).json({ missatge: 'No s\'han trobat armes associades als skins seleccionats. No hi ha missions disponibles.' });
    }

    // 3. Obtenir missions assignades a l'usuari amb dades de missió
    const [usuarisMissions] = await connection.execute(`
      SELECT um.id AS usuaris_missions_id, m.id AS missio_id, m.nom_missio, m.descripcio, m.objectiu, m.tipus_missio
      FROM USUARIS_MISSIONS um
      JOIN MISSIONS m ON um.missio_id = m.id
      WHERE um.usuari_id = ?
    `, [usuariId]);

    if (usuarisMissions.length === 0) {
      return res.status(200).json({ missatge: 'No hi ha missions assignades a l\'usuari.' });
    }

    // 4. Tipus de missió que volem buscar (ordre)
    const tipusMissioSeq = [2, 3, 4];
    let missioFinal = null;

    // 5. Cercar primera missió no completada per arma i tipus
    for (const { arma_id: armaId, nom_arma: nomArma } of armes) {
      for (const tipus of tipusMissioSeq) {

        // Filtrar missions assignades per tipus
        const missionsFiltrades = usuarisMissions.filter(um => um.tipus_missio === tipus);

        for (const um of missionsFiltrades) {
          // Consultar progrés específic per arma dins la missió assignada
          const [missionsArmesProgress] = await connection.execute(`
            SELECT progress
            FROM MISSIONS_ARMES
            WHERE usuaris_missions_id = ? AND arma_id = ?
          `, [um.usuaris_missions_id, armaId]);

          if (missionsArmesProgress.length === 0) continue;

          const progress = Number(missionsArmesProgress[0].progress);
          const objectiu = Number(um.objectiu);

          if (progress < objectiu) {
            // Missió no completada trobada
            missioFinal = {
              id: um.missio_id,
              nom_missio: um.nom_missio,
              descripcio: um.descripcio,
              objectiu: um.objectiu,
              progress,
              armaId,
              nomArma,
              tipusMissio: tipus
            };
            break;
          }
        }

        if (missioFinal) break;
      }
      if (missioFinal) break;
    }

    if (!missioFinal) {
      return res.status(200).json({ missatge: 'Totes les missions estan completades per totes les armes associades als skins seleccionats.' });
    }

    // 6. Retornar la missió trobada amb l’arma associada
    return res.status(200).json({
      missatge: 'Missió d\'arma recuperada correctament',
      arma: missioFinal.nomArma,
      missio: {
        id: missioFinal.id,
        nom_missio: missioFinal.nom_missio,
        descripcio: missioFinal.descripcio,
        objectiu: missioFinal.objectiu,
        progres: missioFinal.progress,
        tipus_missio: missioFinal.tipusMissio
      }
    });

  } catch (err) {
    console.error('Error al recuperar la missió d\'arma:', err);
    return res.status(500).json({ error: 'Error recuperant la missió d\'arma' });
  }
};




exports.incrementarProgresArma = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari ID invàlid' });
  }

  try {
    const connection = await connectDB();

    // 1. Obtenir els skins seleccionats per l'usuari
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

    // 2. Obtenir les armes associades a aquests skins
    const [armes] = await connection.execute(`
      SELECT DISTINCT a.id AS arma_id, a.nom AS nom_arma
      FROM SKINS_ARMES sa
      JOIN ARMES a ON sa.arma = a.id
      WHERE sa.skin IN (${placeholders})
    `, skinsIds);

    if (armes.length === 0) {
      return res.status(200).json({ missatge: 'Cap arma trobada per als skins seleccionats. No hi ha missions a incrementar.' });
    }

    // 3. Obtenir les missions assignades a l'usuari (USUARIS_MISSIONS)
    const [usuarisMissions] = await connection.execute(`
      SELECT id
      FROM USUARIS_MISSIONS
      WHERE usuari_id = ?
    `, [usuariId]);

    if (usuarisMissions.length === 0) {
      return res.status(200).json({ missatge: 'L\'usuari no té missions assignades.' });
    }

    const usuarisMissionsIds = usuarisMissions.map(um => um.id);
    const umPlaceholders = usuarisMissionsIds.map(() => '?').join(',');

    const tipusMissioSeq = [2, 3, 4];
    let missioActualitzada = null;

    for (const { arma_id: armaId, nom_arma: nomArma } of armes) {
      for (const tipus of tipusMissioSeq) {
        // 4. Buscar missions armes que estiguin relacionades amb missions assignades i de tipus concret
        const [missions] = await connection.execute(`
          SELECT ma.id, ma.progress, m.objectiu, ma.usuaris_missions_id, m.id AS missio_id
          FROM MISSIONS_ARMES ma
          JOIN USUARIS_MISSIONS um ON ma.usuaris_missions_id = um.id
          JOIN MISSIONS m ON m.id = um.missio_id
          WHERE ma.arma_id = ? AND um.usuari_id = ? AND m.tipus_missio = ?
        `, [armaId, usuariId, tipus]);

        if (missions.length === 0) continue;

        const missioNoCompleta = missions.find(m => Number(m.progress) < Number(m.objectiu));
        if (missioNoCompleta) {
          const { id: maId, progress, objectiu } = missioNoCompleta;
          const nouProgres = progress + 1;

          await connection.execute(`
            UPDATE MISSIONS_ARMES
            SET progress = ?
            WHERE id = ?
          `, [nouProgres, maId]);

          missioActualitzada = {
            missatge: `Progrés incrementat per a la missió ${missioNoCompleta.missio_id} (tipus ${tipus}) de l'arma ${nomArma}`,
            missio: missioNoCompleta.missio_id,
            progres: nouProgres,
            tipus,
            arma: nomArma
          };
          break;
        }
      }
      if (missioActualitzada) break;
    }

    if (!missioActualitzada) {
      return res.status(200).json({ missatge: 'Totes les missions estan completades o no hi ha missions disponibles. No hi ha res a incrementar.' });
    }

    res.status(200).json(missioActualitzada);

  } catch (err) {
    console.error('Error incrementant el progrés de la missió d\'arma:', err.message);
    res.status(500).json({ error: 'Error al incrementar el progrés de la missió d\'arma' });
  }
};











