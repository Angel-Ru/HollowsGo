const { connectDB, sql } = require('../config/dbConfig');


exports.getArmesPredefinidesPerSkin = async (req, res) => {
  try {
    const { skin_id, usuari_id } = req.params;  // Ara agafem usuari_id també
    const connection = await connectDB();

    // Obtenim les armes predefinides per la skin
    const [armes] = await connection.execute(
      `SELECT a.id, a.nom, a.categoria, a.buff_atac
       FROM SKINS_ARMES sa
       JOIN ARMES a ON sa.arma = a.id
       WHERE sa.skin = ?`,
      [skin_id]
    );

    if (armes.length === 0) {
      return res.status(404).send('No s’han trobat armes per a aquesta skin.');
    }

    // Obtenim l'arma equipada (si n'hi ha) per l'usuari i la skin
    const [armaEquipadaRows] = await connection.execute(
      `SELECT a.id, a.nom, a.categoria, a.buff_atac
       FROM USUARI_SKIN_ARMES ae
       JOIN ARMES a ON ae.arma_id = a.id
       WHERE ae.usuari_id = ? AND ae.skin_id = ?`,
      [usuari_id, skin_id]
    );

    const armaEquipada = armaEquipadaRows.length > 0 ? armaEquipadaRows[0] : null;

    return res.status(200).json({
      armesPredefinides: armes,
      armaEquipada,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error en obtenir les armes predefinides.");
  }
};


exports.equiparArmaASkin = async (req, res) => {
    try {
        const { usuari_id, skin_id, arma_id } = req.body;
        const connection = await connectDB();

        const [validArma] = await connection.execute(
            'SELECT 1 FROM SKINS_ARMES WHERE skin = ? AND arma = ?',
            [skin_id, arma_id]
        );

        if (validArma.length === 0) {
            return res.status(400).send('Aquesta arma no és vàlida per a aquesta skin.');
        }

        const [existing] = await connection.execute(
            'SELECT 1 FROM USUARI_SKIN_ARMES WHERE usuari = ? AND skin = ?',
            [usuari_id, skin_id]
        );

        if (existing.length > 0) {
            await connection.execute(
                'UPDATE USUARI_SKIN_ARMES SET arma = ? WHERE usuari = ? AND skin = ?',
                [arma_id, usuari_id, skin_id]
            );
        } else {
            await connection.execute(
                'INSERT INTO USUARI_SKIN_ARMES (usuari, skin, arma) VALUES (?, ?, ?)',
                [usuari_id, skin_id, arma_id]
            );
        }

        res.status(200).json({ message: "Arma equipada correctament a la skin." });
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en equipar l'arma.");
    }
};

