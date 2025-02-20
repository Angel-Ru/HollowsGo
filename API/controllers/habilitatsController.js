const { connectDB, sql } = require('../config/dbConfig');

// Obtenir la habilitat llegendaria d'una skin per id
exports.getLegendaryAbilityBySkinId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT h.* 
                FROM HABILITATS h
                JOIN SKINS s ON h.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir la habilitat llegendaria d'una skin per nom
exports.getLegendaryAbilityBySkinName = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT h.* 
                FROM HABILITATS h
                JOIN SKINS s on h.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Crear una nova habilitat
exports.createAbility = async (req, res) => {
    try {
        const { nom, descripcio, tipus, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('descripcio', sql.VarChar(255), descripcio)
            .input('tipus', sql.VarChar(50), tipus)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO HABILITATS (nom, descripcio, tipus, skin_id)
                VALUES (@nom, @descripcio, @tipus, @skin_id)
            `);
        res.status(201).send('Habilitat afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'habilitat');
    }
};

// Eliminar una habilitat per ID
exports.deleteAbilityById = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM HABILITATS WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Habilitat no trobada');
        }

        res.send('Habilitat eliminada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar l\'habilitat');
    }
};
