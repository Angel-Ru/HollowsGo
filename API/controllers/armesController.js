const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Armes
 *   description: Operacions relacionades amb les armes
 */

/**
 * @swagger
 * /armes/{skin_id}/:
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
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                     description: ID de l'arma
 *                   nom:
 *                     type: string
 *                     description: Nom de l'arma
 *                   descripcio:
 *                     type: string
 *                     description: Descripció de l'arma
 *                   skin_id:
 *                     type: integer
 *                     description: ID de la skin associada
 *       404:
 *         description: No s'han trobat armes per a aquesta skin
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "No s'han trobat armes per a aquesta skin"
 *       500:
 *         description: Error en la consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "Error en la consulta"
 */
exports.getArmesPerSkinId = async (req, res) => {
    try {
        const { id } = req.params;

        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, id)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS_ARMES sa ON a.id = sa.arma
                         JOIN SKINS s ON sa.skin = s.id
                WHERE s.id = @id
            `);

        if (result.recordset.length > 0) {
            res.status(200).json(result.recordset);
        } else {
            res.status(404).send("No s'han trobat armes per a aquesta skin");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en la consulta");
    }
};

/**
 * @swagger
 * /armes/nom/{nom_skin}:
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
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                     description: ID de l'arma
 *                   nom:
 *                     type: string
 *                     description: Nom de l'arma
 *                   descripcio:
 *                     type: string
 *                     description: Descripció de l'arma
 *                   skin_id:
 *                     type: integer
 *                     description: ID de la skin associada
 *       404:
 *         description: No s'han trobat armes per a aquesta skin
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "No s'han trobat armes per a aquesta skin"
 *       500:
 *         description: Error en la consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "Error en la consulta"
 */
exports.getArmesPerSkinNom = async (req, res) => {
    try {
        const { nom } = req.params;

        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS_ARMES sa ON a.id = sa.arma
                         JOIN SKINS s ON sa.skin = s.id
                WHERE s.nom = @nom
            `);

        if (result.recordset.length > 0) {
            res.status(200).json(result.recordset);
        } else {
            res.status(404).send("No s'han trobat armes per a aquesta skin");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en la consulta");
    }
};

/**
 * @swagger
 * /armes/{id}/{arma_id}:
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
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: integer
 *                   description: ID de l'arma
 *                 nom:
 *                   type: string
 *                   description: Nom de l'arma
 *                 descripcio:
 *                   type: string
 *                   description: Descripció de l'arma
 *                 skin_id:
 *                   type: integer
 *                   description: ID de la skin associada
 *       404:
 *         description: No s'ha trobat l'arma per a aquesta skin
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "No s'ha trobat l'arma per a aquesta skin"
 *       500:
 *         description: Error en la consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "Error en la consulta"
 */
exports.getArmaSkinId = async (req, res) => {
    try {
        const { id, arma_id } = req.params;

        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, id)
            .input('arma_id', sql.Int, arma_id)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS_ARMES sa ON a.id = sa.arma
                         JOIN SKINS s ON sa.skin = s.id
                WHERE s.id = @id AND a.id = @arma_id
            `);

        if (result.recordset.length > 0) {
            res.status(200).json(result.recordset[0]);
        } else {
            res.status(404).send("No s'ha trobat l'arma per a aquesta skin");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en la consulta");
    }
};

/**
 * @swagger
 * /armes/{nom_skin}/{nom_arma}:
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
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 id:
 *                   type: integer
 *                   description: ID de l'arma
 *                 nom:
 *                   type: string
 *                   description: Nom de l'arma
 *                 descripcio:
 *                   type: string
 *                   description: Descripció de l'arma
 *                 skin_id:
 *                   type: integer
 *                   description: ID de la skin associada
 *       404:
 *         description: No s'ha trobat l'arma per a aquesta skin
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "No s'ha trobat l'arma per a aquesta skin"
 *       500:
 *         description: Error en la consulta
 *         content:
 *           application/json:
 *             schema:
 *               type: string
 *               example: "Error en la consulta"
 */
exports.getArmaSkinNom = async (req, res) => {
    try {
        const { nom, arma_nom } = req.params;

        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('arma_nom', sql.VarChar(50), arma_nom)
            .query(`
                SELECT a.*
                FROM ARMES a
                         JOIN SKINS_ARMES sa ON a.id = sa.arma
                         JOIN SKINS s ON sa.skin = s.id
                WHERE s.nom = @nom AND a.nom = @arma_nom
            `);

        if (result.recordset.length > 0) {
            res.status(200).json(result.recordset[0]);
        } else {
            res.status(404).send("No s'ha trobat l'arma per a aquesta skin");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en la consulta");
    }
};

/**
 * @swagger
 * /armes:
 *   post:
 *     tags: [Armes]
 *     summary: Crear una nova arma
 *     description: |
 *       Afegeix una nova arma a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "exemple@gmail.com",
 *         "nom": "Espasa Llarga",
 *         "categoria": 1,
 *         "buff_atac": 10
 *       }
 *       ```
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nom
 *               - categoria
 *               - buff_atac
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom de l'arma.
 *                 example: "Espasa Llarga"
 *               categoria:
 *                 type: integer
 *                 description: Categoria de l'arma.
 *                 example: 1
 *               buff_atac:
 *                 type: integer
 *                 description: Buff d'atac que proporciona l'arma.
 *                 example: 10
 *     responses:
 *       201:
 *         description: Arma afegida correctament
 *       500:
 *         description: Error en inserir l'arma
 */
exports.crearArma = async (req, res) => {
    try {
        const { nom, categoria, buff_atac } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('categoria', sql.Int, categoria)
            .input('buff_atac', sql.Int, buff_atac)
            .query(`
                INSERT INTO ARMES (nom, buff_atac, categoria)
                VALUES (@nom, @buff_atac, @categoria)
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
 *     description: |
 *       Elimina una arma de la base de dades mitjançant el seu ID.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
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