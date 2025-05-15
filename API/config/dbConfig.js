const mysql = require('mysql2/promise');

const dbConfig = {
    host: 'turntable.proxy.rlwy.net',
    port: 10233,
    user: 'root',
    password: 'MNVyvLmZogsxlkmHKzsztJFowEvoIDZN',
    database: 'hollowsgo' // Asegúrate de que esta base de datos exista
};

let pool;

async function connectDB() {
    if (!pool) {
        try {
            pool = await mysql.createPool(dbConfig);
            console.log('Conexión a la base de datos MySQL establecida correctamente');
        } catch (err) {
            console.error('Error al conectar con la base de datos MySQL:', err);
            throw err;
        }
    }
    return pool;
}

module.exports = { connectDB };
