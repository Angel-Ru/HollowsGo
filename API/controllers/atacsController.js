const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Atacs
 *   description: Endpoints per gestionar atacs
 */

/**
 * @swagger
 * /skins/{id}/atacs:
 *   get:
 *     summary: Obtenir l'atac d'una skin per ID
 *     description: Retorna l'atac associat a una skin específica mitjançant el seu ID.
 *     tags: [Atacs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la skin
 *     responses:
 *       200:
 *         description: Detalls de l'atac de la skin
 *       404:
 *         description: No s'ha trobat l'atac per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getAtacSkinPerId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT a.*
                FROM ATACS a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/{nom}/atacs:
 *   get:
 *     summary: Obtenir l'atac d'una skin per nom
 *     description: Retorna l'atac associat a una skin específica mitjançant el seu nom.
 *     tags: [Atacs]
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de la skin
 *     responses:
 *       200:
 *         description: Detalls de l'atac de la skin
 *       404:
 *         description: No s'ha trobat l'atac per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getAtacSkinPerNom = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT a.*
                FROM ATACS a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /atacs:
 *   post:
 *     summary: Crear un nou atac
 *     description: Afegeix un nou atac a la base de dades.
 *     tags: [Atacs]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               dany:
 *                 type: integer
 *               tipus:
 *                 type: string
 *               skin_id:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Atac afegit correctament
 *       500:
 *         description: Error en inserir l'atac
 */
exports.crearAtac = async (req, res) => {
    try {
        const { nom, dany, tipus, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('dany', sql.Int, dany)
            .input('tipus', sql.VarChar(50), tipus)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO ATACS (nom, dany, tipus, skin_id)
                VALUES (@nom, @dany, @tipus, @skin_id)
            `);
        res.status(201).send('Atac afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'atac');
    }
};

/**
 * @swagger
 * /atacs/{id}:
 *   delete:
 *     summary: Eliminar un atac per ID
 *     description: Elimina un atac de la base de dades mitjançant el seu ID.
 *     tags: [Atacs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'atac a eliminar
 *     responses:
 *       200:
 *         description: Atac eliminat correctament
 *       404:
 *         description: Atac no trobat
 *       500:
 *         description: Error en eliminar l'atac
 */
exports.borrarAtacPerId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM ATACS WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Atac no trobat');
        }

        res.send('Atac eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar l\'atac');
    }
};