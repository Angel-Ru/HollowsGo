const { connectDB, sql } = require('../config/dbConfig');

exports.updateVidaActualSkin = async (req, res) => {
    try {
        const connection = await connectDB();
        const skinId = req.params.id;
        const { vida_actual, usuari_id } = req.body;

        // Validació bàsica
        if (vida_actual === undefined || isNaN(vida_actual)) {
            return res.status(400).json({ error: 'Valor de vida_actual invàlid.' });
        }

        if (!usuari_id) {
            return res.status(400).json({ error: 'Falta l\'usuari_id.' });
        }

        // Validar que la skin existeix
        const [skinCheck] = await connection.execute(
            'SELECT id FROM SKINS WHERE id = ?',
            [skinId]
        );

        if (skinCheck.length === 0) {
            return res.status(404).json({ error: 'Skin no trobada.' });
        }

        // Validar que l'entrada a USUARI_SKIN_ARMES existeix
        const [usuariSkinCheck] = await connection.execute(
            'SELECT 1 FROM USUARI_SKIN_ARMES WHERE usuari = ? AND skin = ?',
            [usuari_id, skinId]
        );

        if (usuariSkinCheck.length === 0) {
            return res.status(404).json({ error: 'Aquesta skin no està assignada a l\'usuari.' });
        }

        // Actualitzar la vida actual per aquell usuari i skin
        await connection.execute(
            'UPDATE USUARI_SKIN_ARMES SET vida_actual = ? WHERE usuari = ? AND skin = ?',
            [vida_actual, usuari_id, skinId]
        );
        console.log(res);
        res.status(200).json({ message: 'Vida actualitzada correctament.' });

    } catch (err) {
        console.error('Error a updateVidaActualSkin:', err);
        res.status(500).json({ error: 'Error intern del servidor.' });
    }
};

