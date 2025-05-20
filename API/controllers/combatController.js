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

exports.getVidaActualSkin = async (req, res) => {
    try {
        const connection = await connectDB();
        const skinId = req.params.id;
        const usuari_id = req.query.usuari_id;

        if (!usuari_id) {
            return res.status(400).json({ error: 'Falta l\'usuari_id com a paràmetre.' });
        }

        // Comprovar que la skin existeix i obtenir el personatge associat
        const [skinCheck] = await connection.execute(
            'SELECT id, personatge FROM SKINS WHERE id = ?',
            [skinId]
        );

        if (skinCheck.length === 0) {
            return res.status(404).json({ error: 'Skin no trobada.' });
        }

        const personatgeId = skinCheck[0].personatge;

        // Comprovar si hi ha vida_actual per usuari i skin
        const [result] = await connection.execute(
            'SELECT vida_actual FROM USUARI_SKIN_ARMES WHERE usuari = ? AND skin = ?',
            [usuari_id, skinId]
        );

        let vidaActual;

        if (result.length === 0 || result[0].vida_actual === null) {
            // No hi ha fila o vida_actual és null: agafar vida_base del personatge
            const [personatgeResult] = await connection.execute(
                'SELECT vida_base FROM PERSONATGES WHERE id = ?',
                [personatgeId]
            );

            if (personatgeResult.length === 0) {
                return res.status(404).json({ error: 'Personatge no trobat per a aquesta skin.' });
            }

            vidaActual = personatgeResult[0].vida_base;
        } else {
            vidaActual = result[0].vida_actual;
        }

        res.status(200).json({ vida_actual: vidaActual });

    } catch (err) {
        console.error('Error a getVidaActualSkin:', err);
        res.status(500).json({ error: 'Error intern del servidor.' });
    }
};




