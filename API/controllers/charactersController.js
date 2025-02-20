const { connectDB, sql } = require('../config/dbConfig');

// Obtenir tots els personatges
exports.getAllCharacters = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM PERSONATGES');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir un personatge per ID
exports.getCharacterById = async (req, res) => {
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

// Obtenir un personatge per nom
exports.getCharacterByName = async (req, res) => {
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

// Crear un nou personatge
exports.createCharacter = async (req, res) => {
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

// Eliminar un personatge per ID
exports.deleteCharacterById = async (req, res) => {
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

