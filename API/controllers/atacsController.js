const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Atacs
 *   description: Endpoints per gestionar atacs
 */

/**
 * @swagger
 * /atacs/{skin_id}:
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
        const { id } = req.params;

        const pool = await connectDB(); // conexión a MySQL
        const [rows] = await pool.execute(`
            SELECT a.*
            FROM ATACS a
                     JOIN SKINS s ON a.id = s.atac
            WHERE s.id = ?
        `, [id]);

        res.send(rows.length > 0 ? rows : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /atacs/nom/{skin_nom}:
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
        const { nom } = req.params;

        const pool = await connectDB(); // conexión MySQL
        const [rows] = await pool.execute(`
            SELECT a.*
            FROM ATACS a
                     JOIN SKINS s ON a.id = s.atac
            WHERE s.nom = ?
        `, [nom]);

        res.send(rows.length > 0 ? rows : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /atacs/:
 *   post:
 *     summary: Crear un nou atac
 *     description: |
 *       Afegeix un nou atac a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "exemple@gmail.com",
 *         "nom": "Atac Nou",
 *         "mal": 50
 *       }
 *       ```
 *     tags: [Atacs]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nom
 *               - mal
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom de l'atac.
 *                 example: "Atac Nou"
 *               mal:
 *                 type: integer
 *                 description: Mal que causa l'atac.
 *                 example: 50
 *     responses:
 *       201:
 *         description: Atac afegit correctament
 *       500:
 *         description: Error en inserir l'atac
 */
exports.crearAtac = async (req, res) => {
    try {
        const { nom, mal } = req.body;

        const pool = await connectDB(); // conexión MySQL
        await pool.execute(`
            INSERT INTO ATACS (nom, mal)
            VALUES (?, ?)
        `, [nom, mal]);

        res.status(201).send('Atac afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en inserir l'atac");
    }
};

/**
 * @swagger
 * /atacs/{id}:
 *   delete:
 *     summary: Eliminar un atac per ID
 *     description: |
 *       Elimina un atac de la base de dades mitjançant el seu ID.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
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
        const { id } = req.params;

        const pool = await connectDB(); // conexión a MySQL
        const [result] = await pool.execute(
            'DELETE FROM ATACS WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).send('Atac no trobat');
        }

        res.send('Atac eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en eliminar l'atac");
    }
};
