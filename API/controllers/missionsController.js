const { connectDB, sql } = require('../config/dbConfig');



exports.assignarMissionsDiaries = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) return res.status(400).json({ error: 'Usuari invàlid' });

  try {
    const avui = new Date().toISOString().split('T')[0];
    const connection = await connectDB();

    // 1. Assignar missions fixes
    const [fixes] = await connection.execute(`
      SELECT id FROM MISSIONS WHERE fixa = TRUE
    `);

    for (const missio of fixes) {
      await connection.execute(`
        INSERT IGNORE INTO MISSIONS_DIARIES (usuari, missio, data_assig)
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

    // 3. Assignar si no existeix
    await connection.execute(`
      INSERT IGNORE INTO MISSIONS_DIARIES (usuari, missio, data_assig)
      VALUES (?, ?, ?)
    `, [usuariId, variableDelDia.id, avui]);

    // 4. Recuperar les missions diaries assignades avui per l’usuari
    const [missionsAssignades] = await connection.execute(`
      SELECT md.id, md.usuari, md.missio, md.data_assig, m.nom_missio, m.descripcio
      FROM MISSIONS_DIARIES md
      JOIN MISSIONS m ON md.missio = m.id
      WHERE md.usuari = ? AND md.data_assig = ?
      ORDER BY md.missio
    `, [usuariId, avui]);

    console.log(res)
    res.status(200).json({ missatge: 'Missions assignades correctament!', missions: missionsAssignades });

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error assignant missions' });
  }
};
