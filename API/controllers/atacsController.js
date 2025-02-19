const { connectDB, sql } = require('../config/dbConfig');

// Obtenir l'atac d'una skin per id
exports.getAttackBySkinId = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT a.* 
                FROM ATACS a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Obtenir l'atac d'una skin per nom
exports.getAttackBySkinName = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT a.* 
                FROM ATACS a
                JOIN SKINS s ON a.skin_id = s.id
                WHERE s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat l\'atac per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Crear un nou atac
exports.createAttack = async (req, res) => {
    try {
        const { nom, dany, tipus, skin_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('dany', sql.Int, dany)
            .input('tipus', sql.VarChar(50), tipus)
            .input('skin_id', sql.Int, skin_id)
            .query(`
                INSERT INTO ATACS (nom, dany, tipus, skin_id)
                VALUES (@nom, @dany, @tipus, @skin_id)
            `);
        res.status(201).send('Atac afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir l\'atac');
    }
};

// Eliminar un atac per ID
exports.deleteAttackById = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM ATACS WHERE id = @id');

        if (result.rowsAffected[0] === 0) {
            return res.status(404).send('Atac no trobat');
        }

        res.send('Atac eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar l\'atac');
    }
};
