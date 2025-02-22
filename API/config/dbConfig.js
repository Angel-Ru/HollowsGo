const sql = require('mssql');

const dbConfig = {
    server: 'hollowsho.database.windows.net',
    user: 'angel',
    password: 'CalaClara21.',
    database: 'hollowsgo',
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
};

let poolPromise;

async function connectDB() {
    if (!poolPromise) {
        poolPromise = sql.connect(dbConfig).then(pool => {
            console.log('Connexió a la base de dades establerta correctament');
            return pool;
        }).catch(err => {
            console.error('Error amb la connexió a la base de dades:', err);
            throw err;
        });
    }
    return poolPromise;
}

module.exports = { connectDB, sql };
