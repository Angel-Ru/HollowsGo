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

    // 1. Obtenir els títols dels personatges que té l'usuari via BIBLIOTECA
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







