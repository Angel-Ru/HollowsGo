const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * /skins/{id}/habilitats:
 *   get:
 *     summary: Obtenir la habilitat llegendària d'una skin per ID
 *     description: Retorna la habilitat llegendària associada a una skin específica mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la skin
 *     responses:
 *       200:
 *         description: Detalls de la habilitat de la skin
 *       404:
 *         description: No s'ha trobat la habilitat per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getHabilitatId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT h.*
                FROM HABILITATS h
                         JOIN SKINS s ON h.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/{nom}/habilitats:
 *   get:
 *     summary: Obtenir la habilitat llegendària d'una skin per nom
 *     description: Retorna la habilitat llegendària associada a una skin específica mitjançant el seu nom.
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de la skin
 *     responses:
 *       200:
 *         description: Detalls de la habilitat de la skin
 *       404:
 *         description: No s'ha trobat la habilitat per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getHabilitatSkinNom = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT h.*
                FROM HABILITATS h
                         JOIN SKINS s ON h.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /habilitats:
 *   post:
 *     summary: Crear una nova habilitat
 *     description: Afegeix una nova habilitat a la base de dades.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               descripcio:
 *                 type: string
 *               tipus:
 *                 type: string
 *               skin_id:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Habilitat afegida correctament
 *       500:
 *         description: Error en inserir l'habilitat
 */
exports.crearHabilitat = async (req, res) => {
    try {
        const { nom, descripcio, tipus, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('descripcio', sql.VarChar(255), descripcio)
            .input('tipus', sql.VarChar(50), tipus)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO HABILITATS (nom, descripcio, tipus, skin_id)
                VALUES (@nom, @descripcio, @tipus, @skin_id)
            `);
        res.status(201).send('Habilitat afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'habilitat');
    }
};

/**
 * @swagger
 * /habilitats/{id}:
 *   delete:
 *     summary: Eliminar una habilitat per ID
 *     description: Elimina una habilitat de la base de dades mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'habilitat a eliminar
 *     responses:
 *       200:
 *         description: Habilitat eliminada correctament
 *       404:
 *         description: Habilitat no trobada
 *       500:
 *         description: Error en eliminar l'habilitat
 */
exports.borrarHabilitatId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM HABILITATS WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Habilitat no trobada');
        }

        res.send('Habilitat eliminada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar l\'habilitat');
    }
};