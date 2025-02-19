const { connectDB, sql } = require('../config/dbConfig');

// Obtenir totes les skins d'un personatge
exports.getSkinsByCharacter = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT s.* 
                FROM SKINS s
                JOIN PERSONATGES p ON s.personatge_id = p.id
                WHERE p.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat skins per a aquest personatge');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir totes les skins d'un personatge d'un usuari
exports.getSkinsByUser = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT s.* 
                FROM SKINS s
                JOIN PERSONATGES p ON s.personatge_id = p.id
                JOIN BIBLIOTECA b ON p.id = b.personatge_id
                JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat skins per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir una skin d'un personatge d'un usuari per ID
exports.getSkinByUserAndId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('skin_id', sql.Int, req.params.skin_id)
            .query(`
                SELECT s.* 
                FROM SKINS s
                JOIN PERSONATGES p ON s.personatge_id = p.id
                JOIN BIBLIOTECA b ON p.id = b.personatge_id
                JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id AND s.id = @skin_id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la skin per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir una skin d'un personatge d'un usuari per nom
exports.getSkinByUserAndName = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT s.* 
                FROM SKINS s
                JOIN PERSONATGES p ON s.personatge_id = p.id
                JOIN BIBLIOTECA b ON p.id = b.personatge_id
                JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id AND s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la skin per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Crear una nova skin
exports.createSkin = async (req, res) => {
    try {
        const { nom, descripcio, personatge_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('descripcio', sql.VarChar(255), descripcio)
            .input('personatge_id', sql.Int, personatge_id)
            .query(`
                INSERT INTO SKINS (nom, descripcio, personatge_id)
                VALUES (@nom, @descripcio, @personatge_id)
            `);
        res.status(201).send('Skin afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir la skin');
    }
};

// Eliminar una skin per ID
exports.deleteSkinById = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM SKINS WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Skin no trobada');
        }

        res.send('Skin eliminada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar la skin');
    }
};
