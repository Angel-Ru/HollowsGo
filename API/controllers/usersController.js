const { connectDB, sql } = require('../config/dbConfig');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
require('dotenv').config();

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
            .query('SELECT punts_emmagatzemats, nom FROM USUARIS WHERE nom = @nom');

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

/*
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
*/

/**
 * @swagger
 * /usuaris/{ususari_id}:
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
 * /usuaris/admin/:
 *   post:
 *     tags: [Usuaris]
 *     summary: Crear un usuari administrador
 *     description: |
 *       Afegeix un nou usuari de tipus administrador (tipo = 1) a la base de dades. Només accessible per administradors.
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "nom": "Admin",
 *         "email": "admin@example.com",
 *         "contrassenya": "AdminP@ssw0rd"
 *       }
 *       ```
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
 * /usuaris/login:
 *   post:
 *     tags: [Usuaris]
 *     summary: Iniciar sessió
 *     description: |
 *       Permet a un usuari iniciar sessió amb el seu correu electrònic i contrasenya.
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "usuari@example.com",
 *         "contrassenya": "P@ssw0rd"
 *       }
 *       ```
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

        // Generar el token JWT
        const token = jwt.sign(
            { id: user.id, tipo: user.tipo },
            process.env.JWT_SECRET
        );

        res.status(200).json({ message: 'Login correcte', user, token });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error en el servidor" });
    }
};

/**
 * @swagger
 * /usuaris/:
 *   post:
 *     tags: [Usuaris]
 *     summary: Crea un usuari normal i retorna un token JWT
 *     description: |
 *       Aquest endpoint permet crear un usuari normal a la base de dades. Si l'usuari es crea correctament, es retorna un token JWT sense expiració.
 *       Els camps `nom`, `email` i `contrassenya` són obligatoris.
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "nom": "Joan",
 *         "email": "joan@example.com",
 *         "contrassenya": "P@ssw0rd"
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
 *               - email
 *               - contrassenya
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom de l'usuari.
 *               email:
 *                 type: string
 *                 description: Correu electrònic de l'usuari.
 *               contrassenya:
 *                 type: string
 *                 description: Contrasenya de l'usuari.
 *     responses:
 *       201:
 *         description: Usuari creat correctament. Retorna l'usuari i el token JWT.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 user:
 *                   type: object
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: ID de l'usuari creat.
 *                     nom:
 *                       type: string
 *                       description: Nom de l'usuari.
 *                     email:
 *                       type: string
 *                       description: Correu electrònic de l'usuari.
 *                     punts_emmagatzemats:
 *                       type: integer
 *                       description: Punts emmagatzemats de l'usuari.
 *                     tipo:
 *                       type: integer
 *                       description: Tipus d'usuari (0 per a usuari normal).
 *                 token:
 *                   type: string
 *                   description: Token JWT generat per a l'usuari.
 *       400:
 *         description: |
 *           Error en la sol·licitud. Pot ser degut a:
 *           - Falten camps obligatoris.
 *           - El correu electrònic o el nom d'usuari ja estan registrats.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "El correu electrònic o el nom d'usuari ja està registrat."
 *       500:
 *         description: Error intern del servidor.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Error al crear l'usuari"
 */
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

        // Crear el registre en la taula PERFIL_USUARI
        await pool.request()
            .input('userId', sql.Int, newUserId)
            .query(`
                INSERT INTO PERFIL_USUARI (usuari)
                VALUES (@userId)
            `);

        // Generar el token JWT sense expiració
        const token = jwt.sign(
            { id: newUserId, tipo: tipo },
            process.env.JWT_SECRET
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


/**
 * @swagger
 * /usuaris/contrasenya:
 *   put:
 *     tags: [Usuaris]
 *     summary: Modifica la contrasenya d'un usuari
 *     description: |
 *       Permet a un usuari modificar la seva contrasenya. Requereix la contrasenya actual per verificar l'identitat.
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "id": 1,
 *         "contrasenyaActual": "P@ssw0rdActual",
 *         "novaContrasenya": "NovaP@ssw0rd"
 *       }
 *       ```
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id:
 *                 type: integer
 *                 description: ID de l'usuari que vol canviar la contrasenya.
 *               contrasenyaActual:
 *                 type: string
 *                 format: password
 *                 description: Contrasenya actual de l'usuari.
 *               novaContrasenya:
 *                 type: string
 *                 format: password
 *                 description: Nova contrasenya que l'usuari vol assignar.
 *             required:
 *               - id
 *               - contrasenyaActual
 *               - novaContrasenya
 *     responses:
 *       200:
 *         description: Contrasenya actualitzada correctament.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Contrasenya actualitzada correctament."
 *       400:
 *         description: Contrasenya actual incorrecta.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Contrasenya actual incorrecta."
 *       404:
 *         description: Usuari no trobat.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Usuari no trobat."
 *       500:
 *         description: Error intern del servidor.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Error en actualitzar la contrasenya."
 */
exports.modificarContrasenyaUsuari = async (req, res) => {
    try {
        const { id, contrasenyaActual, novaContrasenya } = req.body;

        const pool = await connectDB();

        // Obtenir la contrasenya actual de l'usuari
        const userResult = await pool.request()
            .input('id', sql.Int, id)
            .query('SELECT contrassenya FROM USUARIS WHERE id = @id');

        if (userResult.recordset.length === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        const contrasenyaHash = userResult.recordset[0].contrassenya;

        // Verificar la contrasenya actual
        const contrasenyaCorrecta = await bcrypt.compare(contrasenyaActual, contrasenyaHash);
        if (!contrasenyaCorrecta) {
            return res.status(400).send('Contrasenya actual incorrecta.');
        }

        // Generar el hash de la nova contrasenya
        const novaContrasenyaHash = await bcrypt.hash(novaContrasenya, 10);

        // Actualitzar la contrasenya
        await pool.request()
            .input('id', sql.Int, id)
            .input('novaContrasenya', sql.VarChar(255), novaContrasenyaHash)
            .query('UPDATE USUARIS SET contrassenya = @novaContrasenya WHERE id = @id');

        res.status(200).send('Contrasenya actualitzada correctament.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en actualitzar la contrasenya.');
    }
};

/**
 * @swagger
 * /usuaris/nom:
 *   put:
 *     tags: [Usuaris]
 *     summary: Modifica el nom d'un usuari
 *     description: |
 *       Permet a un usuari modificar el seu nom. Requereix la contrasenya actual per verificar l'identitat.
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "id": 1,
 *         "nouNom": "Joan Nou",
 *         "contrasenyaActual": "P@ssw0rdActual"
 *       }
 *       ```
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               id:
 *                 type: integer
 *                 description: ID de l'usuari que vol canviar el nom.
 *               nouNom:
 *                 type: string
 *                 description: Nou nom que l'usuari vol assignar.
 *               contrasenyaActual:
 *                 type: string
 *                 format: password
 *                 description: Contrasenya actual de l'usuari per verificar l'identitat.
 *             required:
 *               - id
 *               - nouNom
 *               - contrasenyaActual
 *     responses:
 *       200:
 *         description: Nom d'usuari actualitzat correctament.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Nom d'usuari actualitzat correctament."
 *       400:
 *         description: Contrasenya actual incorrecta.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Contrasenya actual incorrecta."
 *       404:
 *         description: Usuari no trobat.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Usuari no trobat."
 *       500:
 *         description: Error intern del servidor.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Error en actualitzar el nom d'usuari."
 */
exports.modificarNomUsuari = async (req, res) => {
    try {
        const { id, nouNom, contrasenyaActual } = req.body;

        const pool = await connectDB();

        // Obtenir la contrasenya actual de l'usuari
        const userResult = await pool.request()
            .input('id', sql.Int, id)
            .query('SELECT contrassenya FROM USUARIS WHERE id = @id');

        if (userResult.recordset.length === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        const contrasenyaHash = userResult.recordset[0].contrassenya;

        // Verificar la contrasenya actual
        const contrasenyaCorrecta = await bcrypt.compare(contrasenyaActual, contrasenyaHash);
        if (!contrasenyaCorrecta) {
            return res.status(400).send('Contrasenya actual incorrecta.');
        }

        // Actualitzar el nom de l'usuari
        const result = await pool.request()
            .input('id', sql.Int, id)
            .input('nouNom', sql.VarChar(50), nouNom)
            .query('UPDATE USUARIS SET nom = @nouNom WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        res.status(200).send('Nom d\'usuari actualitzat correctament.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en actualitzar el nom d\'usuari.');
    }
};
//Endpoint per quan jugues una partida actualitzar el nombre de partides jugades
exports.SumarPartidaJugada = async (req, res) => {
    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('UPDATE PERFIL_USUARI SET partides_jugades = partides_jugades + 1 WHERE usuari = @id');
        res.send('Partida juagada sumada');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora de sumar la partida jugada");
    }
};

//Endpoint per quan jugues una partides i la guanyes
exports.SumpartPartidaGuanyada = async (req, res) => {
    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('UPDATE PERFIL_USUARI SET partides_guanyades = partides_guanyades + 1 WHERE usuari = @id');
        res.send('Partida guanydada sumada');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora de sumar la partida guanyada");
    }
};

//Endpoint per quan vols seleccionar i mostrar les partides jugades i guanyades de l'usuari.
exports.MostrarDadesPerfil = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT 
                    pu.partides_jugades, 
                    pu.partides_guanyades,
                    COUNT(DISTINCT b.personatge_id) AS nombre_personatges,
                    SUM(
                        CASE 
                            WHEN b.skin_ids IS NULL OR b.skin_ids = '' THEN 0
                            ELSE LEN(b.skin_ids) - LEN(REPLACE(b.skin_ids, ',', '')) + 1
                        END
                    ) AS nombre_skins
                FROM 
                    PERFIL_USUARI pu
                JOIN 
                    USUARIS u ON u.id = pu.usuari
                JOIN 
                    BIBLIOTECA b ON b.user_id = u.id
                WHERE 
                    u.id = @id
                GROUP BY 
                    pu.partides_jugades, pu.partides_guanyades
            `);

        res.json(result.recordset[0]);
    } catch (error) {
        console.error('Error al obtenir dades del perfil:', error);
        res.status(500).json({ message: 'Error del servidor' });
    }
};
