const mysql = require('mysql2/promise');

const dbConfig = {
    host: 'turntable.proxy.rlwy.net',
    port: 10233,
    user: 'root',
    password: 'MNVyvLmZogsxlkmHKzsztJFowEvoIDZN',
    database: 'hollowsgo'
};

let pool;

async function createNewPool() {
    try {
        const newPool = await mysql.createPool(dbConfig);
        console.log('✅ Conexión a la base de datos MySQL establecida correctamente');
        return newPool;
    } catch (err) {
        console.error('❌ Error al crear el pool:', err);
        throw err;
    }
}

async function connectDB() {
    if (!pool) {
        pool = await createNewPool();
    } else {
        try {
            // Verificamos si el pool sigue vivo
            await pool.query('SELECT 1');
        } catch (err) {
            console.warn('⚠️ Pool cerrado o inválido. Se creará uno nuevo...');
            pool = await createNewPool();
        }
    }
    return pool;
}

module.exports = { connectDB };
