const {connectDB, sql} = require("../config/dbConfig");



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
            return res.status(403).send('Accés denegat. Només per admins.');
        }

        next();
    } catch (error) {
        console.error(error);
        res.status(500).send('Error al verificar el usuario.');
    }

};





