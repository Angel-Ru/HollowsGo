const { connectDB, sql } = require('../config/dbConfig');
const bcrypt = require('bcrypt');

// Obtenir tots els usuaris
async function getUsers(req, res) {
    try {
        const pool = await connectDB();
        const result = await pool.request().query('SELECT * FROM USUARIS');
        res.send(result.recordset);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
}

// Obtenir un usuari per ID
async function getUserById(req, res) {
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
}

// Crear un nou usuari
async function createUser(req, res) {
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
        res.status(201).send('Usuario afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'insertar l'usuari");
    }
}
//Creació de l'usuari de tipus 0(user) sempre
async function createUserType0(req, res) {
    try {
        const { nom, email, contrassenya } = req.body;
        const punts_emmagatzemats = 100;
        const tipo = 0;
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
        res.status(201).send('Usuario afegit correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'insertar l'usuari");
    }
}
// Eliminar un usuari per ID
async function deleteUser(req, res) {
    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM USUARIS WHERE id = @id');
        res.send('Usuari eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'eliminar l'usuari");
    }
}

// Crear un nou usuari (només accessible per a administradors)
async function createUserAdminProtegit(req, res) {
    // Comprovem si l'usuari que fa la petició és administrador
    if (req.user.tipo !== 1) {
        return res.status(403).send('Accés denegat. Necessites permisos d\'administrador.');
    }

    try {
        const { nom, email, contrassenya = 0, } = req.body;
        const punts_emmagatzemats = 100;
        const tipo = 1;
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
        res.status(500).send("Error alhora d'insertar l'usuari");
    }
}

// Eliminar un usuari per ID (només accessible per a administradors)
async function deleteUserProtegit(req, res) {
    // Comprovem si l'usuari que fa la petició és administrador
    if (req.user.tipo !== 1) {
        return res.status(403).send('Accés denegat. Necessites permisos d\'administrador.');
    }

    try {
        const pool = await connectDB();
        await pool.request()
            .input('id', sql.Int, req.params.id)
            .query('DELETE FROM USUARIS WHERE id = @id');
        res.send('Usuari eliminat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error alhora d'eliminar l'usuari");
    }

}

async function login(req, res) {
    try {
        const { email, contrassenya } = req.body;

        const pool = await connectDB();
        const result = await pool.request()
            .input('email', sql.VarChar(50), email)
            .query(`SELECT * FROM USUARIS WHERE email = @email`);

        if (result.recordset.length === 0) {
            return res.status(401).json({ message: "L'usuari no existeix" });
        }

        const user = result.recordset[0]; // Usuario encontrado
        const passwordMatch = await bcrypt.compare(contrassenya, user.contrassenya);

        if (!passwordMatch) {
            return res.status(401).json({ message: "Contrasenya incorrecta" });
        }

        res.status(200).json({ message: 'Login correcte', user });

    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error en el servidor" });
    }
}

module.exports = { getUsers, getUserById, createUser, createUserType0, createUserAdminProtegit, deleteUser, login };
