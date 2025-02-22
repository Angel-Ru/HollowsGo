const { connectDB, sql } = require("../config/dbConfig");

/**
 * @swagger
 * tags:
 *   name: Autenticació
 *   description: Gestió de l'autenticació i verificació d'usuaris.
 */

/**
 * @swagger
 * /verify-admin:
 *   post:
 *     summary: Verificar si un usuari és administrador
 *     description: Aquesta ruta verifica si un usuari amb el correu electrònic proporcionat té rol d'administrador.
 *     tags: [Autenticació]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: El correu electrònic de l'usuari per verificar.
 *                 example: admin@example.com
 *     responses:
 *       200:
 *         description: Accés permès, l'usuari és un administrador.
 *       400:
 *         description: Correu electrònic no proporcionat.
 *       403:
 *         description: Accés denegat, l'usuari no és administrador.
 *       500:
 *         description: Error en la verificació del usuari.
 */
exports.verifyAdminDB = async (req, res, next) => {
    const { email } = req.body;

    if (!email) {
        return res.status(400).send('Es requereix email per verificar.');
    }

    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), email)
            .query('SELECT tipo FROM USUARIS WHERE email = @email');

        const user = result.recordset[0];

        if (!user || user.tipo !== 1) {
            return res.status(403).send('Accés denegat. Només per administradors.');
        }

        next();
    } catch (error) {
        console.error(error);
        res.status(500).send("Error al verificar l'usuari.");
    }

};
