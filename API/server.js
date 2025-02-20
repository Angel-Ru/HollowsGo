const sql = require('mssql');
const bcrypt = require('bcrypt');

const express = require('express');

var app = express();

const bodyParser = require('body-parser');

app.use(bodyParser.json());

const dbConfig ={
    server: 'hollowsho.database.windows.net',
    user: 'angel',
    password: 'CalaClara21.',
    database: 'hollowsgo',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

// Conexió a la base de dades amb reutilització
//poolPromise és una variable que emmagatzema la promesa de la connexió a la base de dades.
let poolPromise;

async function connectDB() {
    if (!poolPromise) {
        poolPromise = sql.connect(dbConfig).then(pool => {
            console.log('Connexió a la base de dades establerta');
            return pool;
        }).catch(err => {
            console.error('Error en la connexió a la base de dades:', err);
            throw err;
        });
    }
    return poolPromise;
}

// Iniciar servidor
app.listen(3000, () => console.log('Servidor iniciat al port 3000'));


// ------------------- MÈTODES GET -------------------

// Obtenir tots els usuaris
app.get('/usuaris', async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM USUARIS');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
});

// Obtenir un usuari per ID
app.get('/usuaris/:id', async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('SELECT * FROM USUARIS WHERE id = @id');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
});

// Obtenir un usuari per correu electrònic
app.get('/usuaris/email/:email', async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), req.params.email)
            .query('SELECT * FROM USUARIS WHERE email = @email');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
});

// Obtenir tots els personatges
app.get('/personatges', async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM PERSONATGES');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
});

// Obtenir un personatge per ID
app.get('/personatges/:id', async (req, res) => {
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
});

// Obtenir un personatge per nom
app.get('/personatges/nom/:nom', async (req, res) => {
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
});

// Obtenir tots els personatges d'un usuari
app.get('/personatges/usuari/:id', async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT p.* 
                FROM PERSONATGES p
                JOIN BIBLIOTECA b ON p.id = b.personatge_id
                JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat personatges per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
});

//Obtenir totes les skins d'un personatge
app.get('/skins/:id', async (req, res) => {
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
});

//Obtenir totes les skins d'un personatge d'un usuari
app.get('/skins/usuari/:id', async (req, res) => {
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
});

//Obtenir una skin d'un personatge d'un usuari per id
app.get('/skins/usuari/:id/:skin_id', async (req, res) => {
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
});
//Obtenir una skin d'un personatge d'un usuari per nom
app.get('/skins/usuari/:id/nom/:nom', async (req, res) => {
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
});

//Obtenir totes les armes d'una skin
app.get('/armes/:id', async (req, res) => {
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
});

//Obtenir totes les armes d'una skin per nom
app.get('/armes/nom/:nom', async (req, res) => {
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
});

//Obtenir una arma d'una skin per id
app.get('/armes/:id/:arma_id', async (req, res) => {
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
});

//Obtenir una arma per nom d'una skin per nom
app.get('/armes/nom/:nom/:arma_nom', async (req, res) => {
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
});

//Obtenir la habilitat llegendaria d'una skin per id
app.get('/habilitats/:id', async (req, res) => {
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
});

//Obtenir la habilitat llegendaria d'una skin per nom
app.get('/habilitats/nom/:nom', async (req, res) => {
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
});

//Obtenir l'atac d'una skin per id
app.get('/atacs/:id', async (req, res) => {
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
});

//Obtenir l'atac d'una skin per nom
app.get('/atacs/nom/:nom', async (req, res) => {
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
});



// ------------------- MÈTODES DELETE -------------------
// Eliminar un usuari per ID
app.delete('/usuaris/:id', async (req, res) => {
    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM USUARIS WHERE id = @id');
        res.send('Usuari eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en l\'eliminació');
    }
});

// ------------------- MÈTODES POST -------------------

// Inserir un usuari
app.post('/usuaris', async (req, res) => {
    try {
        const { nom, email, contrassenya, punts_emmagatzemats = 0, tipo = 0 } = req.body;
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
        res.status(500).send('Error en inserir l\'usuari');
    }
});

// Inserir un personatge
app.post('/personatges', async (req, res) => {
    try {
        const { nom, vida_base, mal_base } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('vida_base', sql.Int, vida_base)
            .input('mal_base', sql.Int, mal_base)
            .query(`
                INSERT INTO PERSONATGES (nom, vida_base, mal_base)
                VALUES (@nom, @vida_base, @mal_base)
            `);
        res.send('Personatge afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir el personatge');
    }
});