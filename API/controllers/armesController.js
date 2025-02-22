const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Armes
 *   description: Operacions relacionades amb les armes
 */

/**
 * @swagger
 * /skins/{id}/armes:
 *   get:
 *     tags: [Armes]
 *     summary: Obtenir totes les armes d'una skin per ID
 *     description: Retorna totes les armes associades a una skin específica mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la skin
 *     responses:
 *       200:
 *         description: Llista d'armes de la skin
 *       404:
 *         description: No s'han trobat armes per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getArmesPerSkinId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat armes per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/{nom}/armes:
 *   get:
 *     tags: [Armes]
 *     summary: Obtenir totes les armes d'una skin per nom
 *     description: Retorna totes les armes associades a una skin específica mitjançant el seu nom.
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de la skin
 *     responses:
 *       200:
 *         description: Llista d'armes de la skin
 *       404:
 *         description: No s'han trobat armes per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getArmesPerSkinNom = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat armes per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/{id}/armes/{arma_id}:
 *   get:
 *     tags: [Armes]
 *     summary: Obtenir una arma d'una skin per ID
 *     description: Retorna una arma específica d'una skin mitjançant els IDs de la skin i de l'arma.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la skin
 *       - in: path
 *         name: arma_id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'arma
 *     responses:
 *       200:
 *         description: Detalls de l'arma
 *       404:
 *         description: No s'ha trobat l'arma per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getArmaSkinId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('arma_id', sql.Int, req.params.arma_id)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id AND a.id = @arma_id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'arma per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/{nom}/armes/{arma_nom}:
 *   get:
 *     tags: [Armes]
 *     summary: Obtenir una arma per nom d'una skin per nom
 *     description: Retorna una arma específica d'una skin mitjançant els noms de la skin i de l'arma.
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de la skin
 *       - in: path
 *         name: arma_nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de l'arma
 *     responses:
 *       200:
 *         description: Detalls de l'arma
 *       404:
 *         description: No s'ha trobat l'arma per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getArmaSkinNom = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .input('arma_nom', sql.VarChar(50), req.params.arma_nom)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom AND a.nom = @arma_nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'arma per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /armes:
 *   post:
 *     tags: [Armes]
 *     summary: Crear una nova arma
 *     description: Afegeix una nova arma a la base de dades.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               tipus:
 *                 type: string
 *               dany:
 *                 type: integer
 *               skin_id:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Arma afegida correctament
 *       500:
 *         description: Error en inserir l'arma
 */
exports.crearArma = async (req, res) => {
    try {
        const { nom, tipus, dany, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('tipus', sql.VarChar(50), tipus)
            .input('dany', sql.Int, dany)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO ARMES (nom, tipus, dany, skin_id)
                VALUES (@nom, @tipus, @dany, @skin_id)
            `);
        res.status(201).send('Arma afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'arma');
    }
};

/**
 * @swagger
 * /armes/{id}:
 *   delete:
 *     tags: [Armes]
 *     summary: Eliminar una arma per ID
 *     description: Elimina una arma de la base de dades mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'arma a eliminar
 *     responses:
 *       200:
 *         description: Arma eliminada correctament
 *       404:
 *         description: Arma no trobada
 *       500:
 *         description: Error en eliminar l'arma
 */
exports.borrarArmaPerId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM ARMES WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Arma no trobada');
        }

        res.send('Arma eliminada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar l\'arma');
    }
};