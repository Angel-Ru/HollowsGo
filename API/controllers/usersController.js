const { connectDB, sql } = require('../config/dbConfig');
const bcrypt = require('bcrypt');


/**
 * @swagger
 * tags:
 *   name: Usuaris
 *   description: Operacions relacionades amb els usuaris de la base de dades
 */

/**
 * @swagger
 * /usuaris:
 *   get:
 *     tags: [Usuaris]
 *     summary: Obtenir tots els usuaris
 *     description: Retorna una llista de tots els usuaris registrats a la base de dades.
 *     responses:
 *       200:
 *         description: Llista d'usuaris
 *       500:
 *         description: Error en la consulta
 */
exports.getUsuaris = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM USUARIS');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error amb la consulta');
    }
};

/**
 * @swagger
 * /usuaris/{id}:
 *   get:
 *     tags: [Usuaris]
 *     summary: Obtenir un usuari per ID
 *     description: Retorna les dades d'un usuari específic mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'usuari
 *     responses:
 *       200:
 *         description: Dades de l'usuari
 *       500:
 *         description: Error en la consulta
 */
exports.getUsuariPerId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('SELECT * FROM USUARIS WHERE id = @id');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error amb la consulta');
    }
};

/**
 * @swagger
 * /usuaris/{nom}/punts:
 *   get:
 *     tags: [Usuaris]
 *     summary: Obtenir els punts d'un usuari per nom
 *     description: Retorna els punts emmagatzemats d'un usuari específic mitjançant el seu nom.
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de l'usuari
 *     responses:
 *       200:
 *         description: Punts de l'usuari
 *       404:
 *         description: No s'ha trobat cap usuari amb aquest nom
 *       500:
 *         description: Error en la consulta
 */
exports.getPuntsUsuari = async (req, res) => {
    try {
        console.log("Nom rebut:", req.params.nom); // 🟢 Debug

        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query('SELECT punts_emmagatzemats FROM USUARIS WHERE nom = @nom');

        console.log("Resultat de la consulta:", result.recordset); // 🟢 Debug

        if (result.recordset.length === 0) {
            console.log("No s'ha trobat cap usuari amb aquest nom.");
        }

        res.send(result.recordset);
    } catch (err) {
        console.error("Error amb la consulta:", err);
        res.status(500).send('Error amb la consulta');
    }
};

/**
 * @swagger
 * /usuaris/normal:
 *   post:
 *     tags: [Usuaris]
 *     summary: Crear un usuari normal
 *     description: Afegeix un nou usuari de tipus normal (tipo = 0) a la base de dades.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               email:
 *                 type: string
 *               contrassenya:
 *                 type: string
 *     responses:
 *       201:
 *         description: Usuari creat correctament
 *       400:
 *         description: Error en les dades proporcionades
 *       500:
 *         description: Error en crear l'usuari
 */
exports.crearUsuariNormal = async (req, res) => {
    try {
        const { nom, email, contrassenya } = req.body;

        if (!nom || !email || !contrassenya) {
            return res.status(400).send('Tots els camps són obligatoris.');
        }

        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), email)
            .input('nom', sql.VarChar(50), nom)
            .query('SELECT COUNT(*) AS count FROM USUARIS WHERE email = @email OR nom = @nom');

        if (result.recordset[0].count > 0) {
            return res.status(400).send("El correu electrònic o el nom d'usuari ja està registrat.");
        }

        const punts_emmagatzemats = 100;
        const tipo = 0;
        const hashedPassword = await bcrypt.hash(contrassenya, 10);

        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('email', sql.VarChar(50), email)
            .input('contrassenya', sql.VarChar(255), hashedPassword)
            .input('punts_emmagatzemats', sql.Int, punts_emmagatzemats)
            .input('tipo', sql.TinyInt, tipo)
            .query(`
                INSERT INTO USUARIS (nom, email, contrassenya, punts_emmagatzemats, tipo)
                VALUES (@nom, @email, @contrassenya, @punts_emmagatzemats, @tipo)
            `);

        const newUser = {
            nom: nom,
            email: email,
            punts_emmagatzemats: punts_emmagatzemats,
            tipo: tipo
        };

        res.status(201).json({
            user: newUser
        });
    } catch (err) {
        console.error(err);
        res.status(500).send("Error al crear l'usuari");
    }
};

/**
 * @swagger
 * /usuaris/{id}:
 *   delete:
 *     tags: [Usuaris]
 *     summary: Eliminar un usuari per ID
 *     description: Elimina un usuari de la base de dades mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'usuari a eliminar
 *     responses:
 *       200:
 *         description: Usuari eliminat correctament
 *       500:
 *         description: Error en eliminar l'usuari
 */
exports.borrarUsuari = async (req, res) => {
    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM USUARIS WHERE id = @id');
        res.send('Usuari eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'eliminar l'usuari");
    }
};

/**
 * @swagger
 * /usuaris/admin:
 *   post:
 *     tags: [Usuaris]
 *     summary: Crear un usuari administrador
 *     description: Afegeix un nou usuari de tipus administrador (tipo = 1) a la base de dades. Només accessible per administradors.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               email:
 *                 type: string
 *               contrassenya:
 *                 type: string
 *     responses:
 *       201:
 *         description: Usuari administrador creat correctament
 *       403:
 *         description: Accés denegat. Només els administradors poden crear usuaris administradors.
 *       500:
 *         description: Error en crear l'usuari administrador
 */
exports.crearUsuariAdmin = async (req, res) => {

    try {
        const { nom, email, contrassenya = 0 } = req.body;
        const punts_emmagatzemats = 100;
        const tipo = 1;
        const hashedPassword = await bcrypt.hash(contrassenya, 10);

        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('email', sql.VarChar(50), email)
            .input('contrassenya', sql.VarChar(255), hashedPassword)
            .input('punts_emmagatzemats', sql.Int, punts_emmagatzemats)
            .input('tipo', sql.TinyInt, tipo)
            .query(`
                INSERT INTO USUARIS (nom, email, contrassenya, punts_emmagatzemats, tipo)
                VALUES (@nom, @email, @contrassenya, @punts_emmagatzemats, @tipo)
            `);
        res.status(201).send('Usuari afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'insertar l'usuari");
    }
};

/**
 * @swagger
 * /login:
 *   post:
 *     tags: [Usuaris]
 *     summary: Iniciar sessió
 *     description: Permet a un usuari iniciar sessió amb el seu correu electrònic i contrasenya.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               contrassenya:
 *                 type: string
 *     responses:
 *       200:
 *         description: Inici de sessió correcte
 *       401:
 *         description: Credencials incorrectes
 *       500:
 *         description: Error en el servidor
 */
exports.login = async (req, res) => {
    try {
        const { email, contrassenya } = req.body;

        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), email)
            .query(`SELECT * FROM USUARIS WHERE email = @email`);

        if (result.recordset.length === 0) {
            return res.status(401).json({ message: "L'usuari no existeix" });
        }

        const user = result.recordset[0]; // Usuari trobat
        const passwordMatch = await bcrypt.compare(contrassenya, user.contrassenya);

        if (!passwordMatch) {
            return res.status(401).json({ message: "Contrasenya incorrecta" });
        }

        res.status(200).json({ message: 'Login correcte', user });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error en el servidor" });
    }
};

exports.crearUsuariNormalToken = async (req, res) => {
    try {
        const { nom, email, contrassenya } = req.body;

        if (!nom || !email || !contrassenya) {
            return res.status(400).send('Tots els camps són obligatoris.');
        }

        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), email)
            .input('nom', sql.VarChar(50), nom)
            .query('SELECT COUNT(*) AS count FROM USUARIS WHERE email = @email OR nom = @nom');

        if (result.recordset[0].count > 0) {
            return res.status(400).send("El correu electrònic o el nom d'usuari ja està registrat.");
        }

        const punts_emmagatzemats = 100;
        const tipo = 0;
        const hashedPassword = await bcrypt.hash(contrassenya, 10);

        const insertResult = await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('email', sql.VarChar(50), email)
            .input('contrassenya', sql.VarChar(255), hashedPassword)
            .input('punts_emmagatzemats', sql.Int, punts_emmagatzemats)
            .input('tipo', sql.TinyInt, tipo)
            .query(`
                INSERT INTO USUARIS (nom, email, contrassenya, punts_emmagatzemats, tipo)
                OUTPUT INSERTED.id
                VALUES (@nom, @email, @contrassenya, @punts_emmagatzemats, @tipo)
            `);

        const newUserId = insertResult.recordset[0].id;

        // Generar el token JWT sense expiració
        const token = jwt.sign(
            { id: newUserId, tipo: tipo }, // Dades incloses al token
            process.env.JWT_SECRET // Clau secreta (sense expiresIn)
        );

        const newUser = {
            id: newUserId,
            nom: nom,
            email: email,
            punts_emmagatzemats: punts_emmagatzemats,
            tipo: tipo
        };


        res.status(201).json({
            user: newUser,
            token: token
        });
    } catch (err) {
        console.error(err);
        res.status(500).send("Error al crear l'usuari");
    }
};