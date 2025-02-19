const { connectDB, sql } = require('../config/dbConfig');

// Obtenir totes les armes d'una skin
exports.getArmsBySkinId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT a.* 
                FROM ARMES a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat armes per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir totes les armes d'una skin per nom
exports.getArmsBySkinName = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT a.* 
                FROM ARMES a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat armes per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir una arma d'una skin per id
exports.getArmById = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('arma_id', sql.Int, req.params.arma_id)
            .query(`
                SELECT a.* 
                FROM ARMES a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id AND a.id = @arma_id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'arma per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir una arma per nom d'una skin per nom
exports.getArmByName = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .input('arma_nom', sql.VarChar(50), req.params.arma_nom)
            .query(`
                SELECT a.* 
                FROM ARMES a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom AND a.nom = @arma_nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'arma per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Crear una nova arma
exports.createArm = async (req, res) => {
    try {
        const { nom, tipus, dany, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('tipus', sql.VarChar(50), tipus)
            .input('dany', sql.Int, dany)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO ARMES (nom, tipus, dany, skin_id)
                VALUES (@nom, @tipus, @dany, @skin_id)
            `);
        res.status(201).send('Arma afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'arma');
    }
};

// Eliminar una arma per ID
exports.deleteArmById = async (req, res) => {
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
