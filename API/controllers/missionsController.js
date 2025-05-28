const { connectDB, sql } = require('../config/dbConfig');



exports.assignarMissionsDiaries = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const avui = new Date().toISOString().split('T')[0];
    const connection = await connectDB();

    // 0. Comprovar si ja té missions assignades avui
    const [missionsExistents] = await connection.execute(`
      SELECT COUNT(*) AS count FROM MISSIONS_DIARIES
      WHERE usuari = ? AND data_assig = ?
    `, [usuariId, avui]);

    if (missionsExistents[0].count === 0) {
      // 1. Assignar missions fixes
      const [fixes] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = TRUE
      `);

      for (const missio of fixes) {
        await connection.execute(`
          INSERT INTO MISSIONS_DIARIES (usuari, missio, data_assig)
          VALUES (?, ?, ?)
        `, [usuariId, missio.id, avui]);
      }

      // 2. Assignar una variable del dia (rotativa)
      const [variables] = await connection.execute(`
        SELECT id FROM MISSIONS WHERE fixa = FALSE ORDER BY id
      `);

      const dia = new Date();
      const index = dia.getDate() % variables.length;
      const variableDelDia = variables[index];

      // 3. Assignar variable del dia
      await connection.execute(`
        INSERT INTO MISSIONS_DIARIES (usuari, missio, data_assig)
        VALUES (?, ?, ?)
      `, [usuariId, variableDelDia.id, avui]);
    }

    // 4. Recuperar les missions assignades avui per l’usuari
    const [missionsAssignades] = await connection.execute(`
      SELECT md.id, md.usuari, md.missio, md.data_assig, md.progress, m.nom_missio, m.descripcio, m.objectiu
FROM MISSIONS_DIARIES md
JOIN MISSIONS m ON md.missio = m.id
WHERE md.usuari = ? AND md.data_assig = ?
ORDER BY md.missio

    `, [usuariId, avui]);

    res.status(200).json({ missatge: 'Missions assignades correctament!', missions: missionsAssignades });

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

    const [rows] = await connection.execute(`
      SELECT md.progress, m.objectiu, md.usuari, m.punts
      FROM MISSIONS_DIARIES md
      JOIN MISSIONS m ON md.missio = m.id
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
    console.error(err);
    res.status(500).json({ error: 'Error incrementant el progrés de la missió' });
  }
};

exports.assignarMissionsTitols = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const connection = await connectDB();

    
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

    // 3. Per cada títol, assignar cada missió si no existeix
    for (const { titol_id } of titolsUsuari) {
      for (const { id: missio_id } of missionsTipus1) {
        const [existeix] = await connection.execute(`
          SELECT 1 FROM MISSIONS_TITOLS
          WHERE titol = ? AND missio = ? AND usuari = ?
        `, [titol_id, missio_id, usuariId]);

        if (existeix.length === 0) {
          await connection.execute(`
            INSERT INTO MISSIONS_TITOLS (titol, missio, usuari)
            VALUES (?, ?, ?)
          `, [titol_id, missio_id, usuariId]);
        }
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
    console.warn('Usuari ID invàlid:', req.params.usuariId);
    return res.status(400).json({ error: 'Usuari invàlid' });
  }

  try {
    const connection = await connectDB();

    // Log inicial
    console.log(`Buscant títol per usuari ${usuariId}`);

    const [titolsUsuari] = await connection.execute(`
      SELECT 
        t.id AS titol_id,
        t.nom_titol AS nom_titol
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

    const [missions] = await connection.execute(`
      SELECT 
        m.id,
        m.nom_missio,
        m.descripcio,
        m.objectiu,
        mt.progres
      FROM MISSIONS_TITOLS mt
      JOIN MISSIONS m ON m.id = mt.missio
      WHERE mt.titol = ? AND mt.usuari = ? AND m.tipus_missio = 1
      LIMIT 1
    `, [titolId, usuariId]);

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

    // Obtenim el titol seleccionat per l'usuari
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

    // Obtenim la missió activa del títol
    const [missions] = await connection.execute(`
      SELECT mt.missio, mt.progres, m.objectiu
      FROM MISSIONS_TITOLS mt
      JOIN MISSIONS m ON m.id = mt.missio
      WHERE mt.titol = ? AND mt.usuari = ? AND m.tipus_missio = 1
      LIMIT 1
    `, [titolId, usuariId]);

    if (missions.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat cap missió de títol per aquest usuari' });
    }

    const { missio, progres, objectiu } = missions[0];

    if (progres >= objectiu) {
      return res.status(200).json({ missatge: 'La missió ja està completada', progres });
    }

    const nouProgres = progres + 1;

    // Actualitzem el progres
    await connection.execute(`
      UPDATE MISSIONS_TITOLS
      SET progres = ?
      WHERE titol = ? AND usuari = ? AND missio = ?
    `, [nouProgres, titolId, usuariId, missio]);

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

    // 1. Obtenir totes les files de la biblioteca de l'usuari
    const [biblioteca] = await connection.execute(`
      SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?
    `, [usuariId]);

    if (biblioteca.length === 0) {
      return res.status(404).json({ error: 'No s\'ha trobat biblioteca per l\'usuari' });
    }

    // 2. Treure totes les skins separades per coma i juntar-les en un array
    let skinsUsuari = [];
    for (const fila of biblioteca) {
      if (fila.skin_ids) {
        const skinsArray = fila.skins.split(',').map(s => s.trim()).filter(s => s.length > 0);
        skinsUsuari = skinsUsuari.concat(skinsArray);
      }
    }

    if (skinsUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat skins a la biblioteca' });
    }

    // Convertir els ids a números
    skinsUsuari = skinsUsuari.map(Number).filter(n => !isNaN(n));

    // 3. Obtenir les armes relacionades amb aquestes skins (sense filtrar tipus)
    const placeholdersSkins = skinsUsuari.map(() => '?').join(',');

    const [armesUsuari] = await connection.execute(`
      SELECT DISTINCT sa.arma
      FROM SKINS_ARMES sa
      WHERE sa.skin IN (${placeholdersSkins})
    `, skinsUsuari);

    if (armesUsuari.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat armes per aquestes skins' });
    }

    // 4. Obtenir la missió de tipus 2 (només una)
    const [missionsTipus2] = await connection.execute(`
      SELECT id FROM MISSIONS WHERE tipus_missio = 2 LIMIT 1
    `);

    if (missionsTipus2.length === 0) {
      return res.status(404).json({ error: 'No s\'han trobat missions de tipus 2' });
    }

    const missio_id = missionsTipus2[0].id;

    // 5. Assignar la missió a cada arma de l'usuari, si no existeix ja
    for (const { arma } of armesUsuari) {
      const [existeix] = await connection.execute(`
        SELECT 1 FROM MISSIONS_ARMES
        WHERE missio = ? AND arma = ? AND usuari = ?
      `, [missio_id, arma, usuariId]);

      if (existeix.length === 0) {
        await connection.execute(`
          INSERT INTO MISSIONS_ARMES (missio, arma, usuari)
          VALUES (?, ?, ?)
        `, [missio_id, arma, usuariId]);
      }
    }

    res.status(200).json({ missatge: 'Missions d’armes assignades correctament!' });

  } catch (err) {
    console.error('Error assignant missions d’armes:', err);
    res.status(500).json({ error: 'Error assignant missions d’armes' });
  }
};







