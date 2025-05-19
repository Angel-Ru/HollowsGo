const { connectDB, sql } = require('../config/dbConfig');

exports.updateVidaActualSkin = async (req, res) => {
    try {
        const connection = await connectDB();
        const skinId = req.params.id;
        const { vida_actual } = req.body;

        // Validació bàsica
        if (vida_actual === undefined || isNaN(vida_actual)) {
            return res.status(400).json({ error: 'Valor de vida_actual invàlid.' });
        }

        // Validar que la skin existeix
        const [skinCheck] = await connection.execute(
            'SELECT id FROM SKINS WHERE id = ?',
            [skinId]
        );

        if (skinCheck.length === 0) {
            return res.status(404).json({ error: 'Skin no trobada.' });
        }

        // Actualitzar la vida actual
        await connection.execute(
            'UPDATE USUARI_SKIN_ARMES SET vida_actual = ? WHERE id = ?',
            [vida_actual, skinId]
        );

        res.status(200).json({ message: 'Vida actualitzada correctament.' });

    } catch (err) {
        console.error('Error a updateVidaActualSkin:', err);
        res.status(500).json({ error: 'Error intern del servidor.' });
    }
};
