const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');

// Middleware para utilitzar CORS y dades en format JSON.
// CORS permet que el servidor accepti sol·licituds de dominis diferents al del servidor,
// això és important per a les aplicacions web que volen interactuar amb APIs
// des de diferents orígens (per exemple, des de localhost:3000 cap a localhost:4000).
// Afegeix capçaleres HTTP adequades per permetre o denegar aquestes sol·licituds de
// recursos a altres orígens.
app.use(cors());
app.use(bodyParser.json());

// Importer les rutes
const characterRoutes = require('../routes/characterRoutes');
const skinRoutes = require('../routes/skinRoutes');
const armesRoutes = require('../routes/armesRoutes');
const habilitatsRoutes = require('../routes/habilitatsRoutes');
const atacsRoutes = require('../routes/atacsRoutes');
const userRoutes = require('../routes/userRoutes');


// Utilitzar les rutes
app.use('/personatges', characterRoutes);// Ruta para personajes
app.use('/skins', skinRoutes);             // Ruta para skins
app.use('/armes', armesRoutes);             // Ruta para armas
app.use('/habilitats', habilitatsRoutes);   // Ruta para habilidades legendarias
app.use('/atacs', atacsRoutes);             // Ruta para ataques
app.use('/usuaris', userRoutes);            // Ruta para usuarios


// Configurar el port en el que treballa el servidor
const port = process.env.PORT || 3000;

// Iniciar el servidor al port especificat
app.listen(port, () => {
    console.log(`Servidor escoltant al port: ${port}`);
});