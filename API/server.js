const sql = require('mssql');
const bcrypt = require('bcryptjs');

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
            console.log('✅ Connexió a la base de dades establerta');
            return pool;
        }).catch(err => {
            console.error('❌ Error en la connexió a la base de dades:', err);
            throw err;
        });
    }
    return poolPromise;
}

const port = process.env.PORT || 50000;
// Iniciar servidor
app.listen(port, () => console.log('🚀 Servidor iniciat al port 3000'));


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