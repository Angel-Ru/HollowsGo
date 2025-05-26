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

  try {
    const connection = await connectDB();

    // Obtenim progress, objectiu, missio (per buscar la descripcio)
    const [rows] = await connection.execute(`
      SELECT md.progress, md.objectiu, md.missio, m.descripcio, md.usuari 
      FROM MISSIONS_DIARIES md
      JOIN MISSIONS m ON md.missio = m.id
      WHERE md.id = ?
    `, [missioDiariaId]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Missió no trobada' });
    }

    const { progress, objectiu, missio, descripcio, usuari } = rows[0];

    if (progress >= objectiu) {
      // Missió ja completada, no fem res
      return res.status(200).json({ missatge: 'Missió ja completada' });
    }

    // Incrementem progress
    const [result] = await connection.execute(`
      UPDATE MISSIONS_DIARIES
      SET progress = progress + 1
      WHERE id = ?
    `, [missioDiariaId]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'Missió no trobada' });
    }

    // Si després d'incrementar progress arribem a l'objectiu, afegim monedes
    if (progress + 1 >= objectiu) {
      // Busquem el número de monedes a la descripció amb regex
      const regex = /(\d+)\s*monedes/i;
      const match = descripcio.match(regex);
      if (match) {
        const monedes = parseInt(match[1]);
        if (!isNaN(monedes)) {
          // Actualitzem punts_emmagatzemats usuari
          await connection.execute(`
            UPDATE USUARIS
            SET punts_emmagatzemats = punts_emmagatzemats + ?
            WHERE id = ?
          `, [monedes, usuari]);
        }
      }
    }

    res.status(200).json({ missatge: 'Progrés incrementat correctament' });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error incrementant el progrés de la missió' });
  }
};




