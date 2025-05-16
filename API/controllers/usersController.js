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
// GET: Tots els usuaris
exports.getUsuaris = async (req, res) => {
    try {
        const connection = await connectDB();
        const [rows] = await connection.execute('SELECT * FROM USUARIS');
        res.send(rows);
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
        const connection = await connectDB();
        const [rows] = await connection.execute('SELECT * FROM USUARIS WHERE id = ?', [req.params.id]);
        res.send(rows);
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
        const connection = await connectDB();
        const [rows] = await connection.execute(
            'SELECT punts_emmagatzemats, nom FROM USUARIS WHERE nom = ?',
            [req.params.nom]
        );
        if (rows.length === 0) {
            return res.status(404).send("No s'ha trobat cap usuari amb aquest nom.");
        }
        console.log(res);
        res.send(rows);
    } catch (err) {
        console.error(err);
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
        const connection = await connectDB();
        await connection.execute('DELETE FROM USUARIS WHERE id = ?', [req.params.id]);
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
        const { nom, email, contrassenya } = req.body;
        const hashedPassword = await bcrypt.hash(contrassenya, 10);
        const connection = await connectDB();
        await connection.execute(
            `INSERT INTO USUARIS (nom, email, contrassenya, punts_emmagatzemats, tipo)
             VALUES (?, ?, ?, ?, ?)`,
            [nom, email, hashedPassword, 100, 1]
        );
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
        const connection = await connectDB();
        const [rows] = await connection.execute(
            'SELECT * FROM USUARIS WHERE email = ?',
            [email]
        );

        if (rows.length === 0) {
            return res.status(401).json({ message: "L'usuari no existeix" });
        }

        const user = rows[0];
        const passwordMatch = await bcrypt.compare(contrassenya, user.contrassenya);

        if (!passwordMatch) {
            return res.status(401).json({ message: "Contrasenya incorrecta" });
        }

        const token = jwt.sign({ id: user.id, tipo: user.tipo }, process.env.JWT_SECRET);
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

        const connection = await connectDB();
        const [existents] = await connection.execute(
            'SELECT COUNT(*) AS count FROM USUARIS WHERE email = ? OR nom = ?',
            [email, nom]
        );

        if (existents[0].count > 0) {
            return res.status(400).send("El correu electrònic o el nom d'usuari ja està registrat.");
        }

        const hashedPassword = await bcrypt.hash(contrassenya, 10);
        const [result] = await connection.execute(
            `INSERT INTO USUARIS (nom, email, contrassenya, punts_emmagatzemats, tipo)
             VALUES (?, ?, ?, ?, ?)`,
            [nom, email, hashedPassword, 100, 0]
        );

        const newUserId = result.insertId;

        await connection.execute(
            'INSERT INTO PERFIL_USUARI (usuari) VALUES (?)',
            [newUserId]
        );

        const token = jwt.sign({ id: newUserId, tipo: 0 }, process.env.JWT_SECRET);

        res.status(201).json({
            user: {
                id: newUserId,
                nom,
                email,
                punts_emmagatzemats: 100,
                tipo: 0
            },
            token
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
        const connection = await connectDB();

        const [rows] = await connection.execute(
            'SELECT contrassenya FROM USUARIS WHERE id = ?',
            [id]
        );

        if (rows.length === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        const passwordMatch = await bcrypt.compare(contrasenyaActual, rows[0].contrassenya);
        if (!passwordMatch) {
            return res.status(400).send('Contrasenya actual incorrecta.');
        }

        const hashedNew = await bcrypt.hash(novaContrasenya, 10);
        await connection.execute(
            'UPDATE USUARIS SET contrassenya = ? WHERE id = ?',
            [hashedNew, id]
        );

        res.status(200).json({ message: "Contrasenya actualitzada correctament." });
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en actualitzar la contrasenya.");
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


// Modificar nom d’usuari
exports.modificarNomUsuari = async (req, res) => {
    try {
        const { id, nouNom, contrasenyaActual } = req.body;
        const connection = await connectDB();

        // Obtenir la contrasenya actual
        const [userRows] = await connection.execute(
            'SELECT contrassenya FROM USUARIS WHERE id = ?',
            [id]
        );

        if (userRows.length === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        const contrasenyaHash = userRows[0].contrassenya;

        // Verificar la contrasenya actual
        const contrasenyaCorrecta = await bcrypt.compare(contrasenyaActual, contrassenyaHash);
        if (!contrasenyaCorrecta) {
            return res.status(400).send('Contrasenya actual incorrecta.');
        }

        // Actualitzar el nom
        const [updateResult] = await connection.execute(
            'UPDATE USUARIS SET nom = ? WHERE id = ?',
            [nouNom, id]
        );

        if (updateResult.affectedRows === 0) {
            return res.status(404).send('Usuari no trobat.');
        }

        res.status(200).send('Nom d\'usuari actualitzat correctament.');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en actualitzar el nom d\'usuari.');
    }
};

// Sumar partida jugada
exports.sumarPartidaJugada = async (req, res) => {
    try {
        const connection = await connectDB();
        const userId = req.params.id;

        await connection.execute(
            'UPDATE PERFIL_USUARI SET partides_jugades = partides_jugades + 1 WHERE usuari = ?',
            [userId]
        );

        res.send('Partida jugada sumada');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora de sumar la partida jugada");
    }
};

// Sumar partida guanyada
exports.sumartPartidaGuanyada = async (req, res) => {
    try {
        const connection = await connectDB();
        const userId = req.params.id;

        await connection.execute(
            'UPDATE PERFIL_USUARI SET partides_guanyades = partides_guanyades + 1 WHERE usuari = ?',
            [userId]
        );

        res.send('Partida guanyada sumada');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora de sumar la partida guanyada");
    }
};

// Endpoint per mostrar dades del perfil de l'usuari
exports.mostrarDadesPerfil = async (req, res) => {
    try {
        const connection = await connectDB();
        const userId = req.params.id;

        const [rows] = await connection.execute(`
            SELECT 
                pu.partides_jugades, 
                pu.partides_guanyades,
                COUNT(DISTINCT b.personatge_id) AS nombre_personatges,
                SUM(
                    CASE 
                        WHEN b.skin_ids IS NULL OR b.skin_ids = '' THEN 0
                        ELSE CHAR_LENGTH(b.skin_ids) - CHAR_LENGTH(REPLACE(b.skin_ids, ',', '')) + 1
                    END
                ) AS nombre_skins
            FROM PERFIL_USUARI pu
            JOIN USUARIS u ON u.id = pu.usuari
            JOIN BIBLIOTECA b ON b.user_id = u.id
            WHERE u.id = ?
            GROUP BY pu.partides_jugades, pu.partides_guanyades
        `, [userId]);

        res.json(rows[0]);
    } catch (error) {
        console.error('Error al obtenir dades del perfil:', error);
        res.status(500).json({ message: 'Error del servidor' });
    }
};

// Obtenir la llista d'avatares
exports.llistarAvatars = async (req, res) => {
    try {
        const connection = await connectDB();
        const [rows] = await connection.execute('SELECT * FROM AVATARS');
        res.json(rows);
    } catch (error) {
        console.error('Error al obtenir els avatars:', error);
        res.status(500).json({ message: 'Error del servidor' });
    }
};

// Actualitzar l'avatar d'un usuari
exports.actualitzarAvatar = async (req, res) => {
    try {
        const { id, avatarId } = req.body;

        if (!id || !avatarId) {
            return res.status(400).json({ message: 'Falten dades requerides' });
        }

        const connection = await connectDB();
        await connection.execute(
            'UPDATE USUARIS SET imatgeperfil = ? WHERE id = ?',
            [avatarId, id]
        );

        res.status(200).json({ message: 'Avatar actualitzat correctament' });
    } catch (err) {
        console.error('Error en actualitzar l\'avatar:', err);
        res.status(500).json({ message: 'Error del servidor' });
    }
};

// Obtenir l'avatar d’un usuari per ID
exports.obtenirAvatar = async (req, res) => {
    try {
        const userId = req.params.id;
        const connection = await connectDB();

        const [rows] = await connection.execute(
            `SELECT a.url
             FROM USUARIS u
             JOIN AVATARS a ON a.id = u.imatgeperfil
             WHERE u.id = ?`,
            [userId]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Usuari no trobat' });
        }

        res.json({ avatarUrl: rows[0].url });
    } catch (error) {
        console.error('Error al obtenir l\'avatar:', error);
        res.status(500).json({ message: 'Error al carregar l\'avatar' });
    }
};
