const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Personatges
 *   description: Endpoints per gestionar personatges
 */

/**
 * @swagger
 * /personatges/:
 *   get:
 *     summary: Obtenir tots els personatges
 *     description: Retorna una llista de tots els personatges registrats a la base de dades.
 *     tags: [Personatges]
 *     responses:
 *       200:
 *         description: Llista de personatges
 *       500:
 *         description: Error en la consulta
 */
exports.getPersonatges = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM PERSONATGES');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /personatges/{id}:
 *   get:
 *     summary: Obtenir un personatge per ID
 *     description: Retorna les dades d'un personatge específic mitjançant el seu ID.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del personatge
 *     responses:
 *       200:
 *         description: Dades del personatge
 *       500:
 *         description: Error en la consulta
 */
exports.getPersonatgeId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('SELECT * FROM PERSONATGES WHERE id = @id');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /personatges/nom/{nom}:
 *   get:
 *     summary: Obtenir un personatge per nom
 *     description: Retorna les dades d'un personatge específic mitjançant el seu nom.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom del personatge
 *     responses:
 *       200:
 *         description: Dades del personatge
 *       500:
 *         description: Error en la consulta
 */
exports.getPersonatgeNom = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query('SELECT * FROM PERSONATGES WHERE nom = @nom');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /personatges/:
 *   post:
 *     summary: Crear un nou personatge
 *     description: |
 *       Afegeix un nou personatge a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "exemple@gmail.com",
 *         "nom": "Personatge Nou",
 *         "vida_base": 100,
 *         "mal_base": 50
 *       }
 *       ```
 *     tags: [Personatges]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nom
 *               - vida_base
 *               - mal_base
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom del personatge.
 *                 example: "Personatge Nou"
 *               vida_base:
 *                 type: integer
 *                 description: Vida base del personatge.
 *                 example: 100
 *               mal_base:
 *                 type: integer
 *                 description: Mal base del personatge.
 *                 example: 50
 *     responses:
 *       201:
 *         description: Personatge afegit correctament
 *       500:
 *         description: Error en inserir el personatge
 */
exports.crearPersonatge = async (req, res) => {
    try {
        const { nom, vida_base, mal_base } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('vida_base', sql.Int, vida_base)
            .input('mal_base', sql.Int, mal_base)
            .query(`INSERT INTO PERSONATGES (nom, vida_base, mal_base) VALUES (@nom, @vida_base, @mal_base)`);
        res.status(201).send('Personatge afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error al inserir el personatge');
    }
};

/**
 * @swagger
 * /personatges/{id}:
 *   delete:
 *     summary: Eliminar un personatge per ID
 *     description: |
 *       Elimina un personatge de la base de dades mitjançant el seu ID.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID del personatge a eliminar
 *     responses:
 *       200:
 *         description: Personatge eliminat correctament
 *       404:
 *         description: Personatge no trobat
 *       500:
 *         description: Error en eliminar el personatge
 */
exports.borrarPersonatgeId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM PERSONATGES WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Personatge no trobat');
        }

        res.send('Personatge eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar el personatge');
    }
};

/**
 * @swagger
 * /personatges/enemics/{nom}/punts:
 *   post:
 *     summary: Obtenir els punts que dona un enemic i sumar-los als punts de l'usuari
 *     description: |
 *       Aquest endpoint obté els punts que dona un enemic específic (mitjançant el seu nom) i suma aquests punts als punts emmagatzemats de l'usuari. Només retorna els punts que dona l'enemic.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de l'enemic
 *       - in: body
 *         name: usuari
 *         required: true
 *         schema:
 *           type: object
 *           properties:
 *             email:
 *               type: string
 *               description: Email de l'usuari al qual se li sumaran els punts
 *     responses:
 *       200:
 *         description: Punts que dona l'enemic
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 punts_enemic:
 *                   type: integer
 *                   description: Punts que dona l'enemic
 *       404:
 *         description: Enemic no trobat o usuari no trobat
 *       500:
 *         description: Error en el servidor
 */
exports.obtenirPuntsEnemicISumarAUsuari = async (req, res) => {
    try {
        const {nom} = req.params; // Nom de l'enemic
        const {email} = req.body; // Email de l'usuari

        //Obtenir els punts que dona l'enemic
        const connection = await connectDB();

        // Primer, obtenir l'ID de l'enemic a través del nom de la taula PERSONATGES
        const [rowsEnemic] = await connection.execute(`
            SELECT e.punts_donats
            FROM ENEMICS e
            INNER JOIN PERSONATGES p ON e.personatge_id = p.id
            WHERE p.nom = ?
        `, [nom]);

        if (rowsEnemic.length === 0) {
            await connection.end();
            return res.status(404).send('Enemic no trobat');
        }

        const puntsEnemic = rowsEnemic[0].punts_donats; // Punts que dona l'enemic

        //Verificar si l'usuari existeix
        const [rowsUsuari] = await connection.execute(`
            SELECT id FROM USUARIS WHERE email = ?
        `, [email]);

        if (rowsUsuari.length === 0) {
            await connection.end();
            return res.status(404).send('Usuari no trobat');
        }

        const usuari_id = rowsUsuari[0].id;

        //Sumar els punts de l'enemic als punts emmagatzemats de l'usuari
        await connection.execute(`
            UPDATE USUARIS
            SET punts_emmagatzemats = punts_emmagatzemats + ?,
                exp_emmagatzemada = exp_emmagatzemada + ?
            WHERE id = ?
        `, [puntsEnemic, puntsEnemic, usuari_id]);

        await connection.end();

        res.status(200).json({ punts_enemic: puntsEnemic });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en el servidor');
    }
};

/**
 * @swagger
 * /personatges/{id}/vida:
 *   put:
 *     summary: Modificar la vida d'un personatge
 *     description: |
 *       Modifica la vida d'un personatge existent a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: L'ID del personatge a modificar
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               vida:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Vida del personatge modificada correctament
 *       500:
 *         description: Error en modificar la vida del personatge
 */
exports.modificarVida = async (req, res) => {
    try {
        const { id } = req.params;
        const { vida } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, id)
            .input('vida', sql.Int, vida)
            .query(`UPDATE PERSONATGES SET vida_base = @vida WHERE id = @id`);
        res.status(200).send('Vida del personatge modificada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en modificar la vida del personatge');
    }
};

/**
 * @swagger
 * /personatges/{id}/mal:
 *   put:
 *     summary: Modificar el mal d'un personatge
 *     description: |
 *       Modifica el mal d'un personatge existent a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *     tags: [Personatges]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: L'ID del personatge a modificar
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               mal:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Mal del personatge modificat correctament
 *       500:
 *         description: Error en modificar el mal del personatge
 */
exports.modificarMal = async (req, res) => {
    try {
        const { id } = req.params;
        const { mal } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, id)
            .input('mal', sql.Int, mal)
            .query(`UPDATE PERSONATGES SET mal_base = @mal WHERE id = @id`);
        res.status(200).send('Mal del personatge modificat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en modificar el mal del personatge');
    }
};