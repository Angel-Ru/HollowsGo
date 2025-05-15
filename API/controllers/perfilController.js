const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Perfil
 *   description: Endpoints per gestionar el perfil de l'usuari.
 */

/**
 * @swagger
 * /perfil_usuari/preferit/{userId}:
 *   get:
 *     summary: Obtenir el personatge i skin preferits d'un usuari
 *     description: Retorna el personatge i el skin preferits d'un usuari específic.
 *     tags: [Perfil_Usuari
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         description: ID de l'usuari
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Informació del personatge i skin preferits de l'usuari
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 userId:
 *                   type: integer
 *                 personatge_preferit:
 *                   type: string
 *                 skin_preferida:
 *                   type: string
 *       404:
 *         description: Usuari no trobat
 *       500:
 *         description: Error en la consulta
 */
exports.getFavoritePersonatge = async (req, res) => {
    try {
        const { userId } = req.params;
        const pool = await connectDB();
        const result = await pool.request()
            .input('userId', userId)
            .query('SELECT p.personatge_preferit, per.nom, p.skin_preferida_id, s.imatge FROM perfil_usuari p join SKINS s on s.id = p.skin_preferida_id join PERSONATGES per on per.id = p.personatge_preferit WHERE usuari = @userId');

        if (result.recordset.length === 0) {
            return res.status(404).send('Usuari no trobat');
        }

        const { personatge_preferit, skin_preferida_id } = result.recordset[0];
        res.send({
            userId,
            personatge_preferit: personatge_preferit || null,
            skin_preferida_id: skin_preferida_id || null
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /perfil_usuari/preferit/{userId}:
 *   put:
 *     summary: Actualitzar el personatge i skin preferits d'un usuari
 *     description: Actualitza el personatge i el skin preferits d'un usuari.
 *     tags: [perfil_usuari]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         description: ID de l'usuari
 *         schema:
 *           type: integer
 *       - in: body
 *         name: body
 *         required: true
 *         description: Dades per actualitzar el personatge i skin preferits
 *         schema:
 *           type: object
 *           properties:
 *             personatge_preferit:
 *               type: string
 *             skin_preferida:
 *               type: string
 *     responses:
 *       200:
 *         description: Personatge i skin preferits actualitzats correctament
 *       400:
 *         description: Dades incorrectes
 *       404:
 *         description: Usuari no trobat
 *       500:
 *         description: Error en la consulta
 */
exports.updateFavoritePersonatge = async (req, res) => {
    try {
        const { userId } = req.params;
        const { personatge_preferit } = req.body;

        if (!personatge_preferit) {
            return res.status(400).send('Dades incorrectes: Personatge preferit mancant');
        }

        const pool = await connectDB();
        const result = await pool.request()
            .input('userId', userId)
            .input('personatge_preferit', personatge_preferit)
            .query(`
                UPDATE perfil_usuari
                SET personatge_preferit = @personatge_preferit
                WHERE usuari = @userId
            `);

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Usuari no trobat');
        }

        res.send('Personatge preferit actualitzat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

exports.updateFavoriteSkin = async (req, res) => {
    try {
        const { userId } = req.params;
        const { skin_preferida_id } = req.body;

        if (!skin_preferida_id) {
            return res.status(400).send('Dades incorrectes: Skin preferida mancant');
        }

        const pool = await connectDB();
        const result = await pool.request()
            .input('userId', userId)
            .input('skin_preferida_id', skin_preferida_id)
            .query(`
                UPDATE perfil_usuari
                SET skin_preferida_id = @skin_preferida_id
                WHERE usuari = @userId
            `);

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Usuari no trobat');
        }

        res.send('Skin preferida actualitzat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};