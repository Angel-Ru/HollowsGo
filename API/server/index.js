const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
require('dotenv').config({ path: '../.env' });

// Middleware para utilitzar CORS y dades en format JSON.
// CORS permet que el servidor accepti sol·licituds de dominis diferents al del servidor,
// això és important per a les aplicacions web que volen interactuar amb APIs
// des de diferents orígens (per exemple, des de localhost:3000 cap a localhost:4000).
// Afegeix capçaleres HTTP adequades per permetre o denegar aquestes sol·licituds de
// recursos a altres orígens.
app.use(cors());
app.use(bodyParser.json());


// Configurar les opcions de Swagger
const swaggerOptions = {
    swaggerDefinition: {
        info: {
            title: 'API-REST HOLLWOS GO',
            version: '1.0.0',
            description: "Documentació de l'API per gestionar personatges, skins, armes, habilitats, atacs i usuaris de l'aplicació HollowsGo. Cal dir que per l'eliminació de alguns objectes s'haurà de respetar les relacions amb la base de dades." +
                "Per exemple: Personatges esta relacionat amb biblioteca i skins, per tant si es vol eliminar un personatge s'haurà de fer primer l'eliminació de les relacions amb la biblioteca i les skins." +
                "Per a més informació sobre les relacions entre objectes, consultar l'imatge que es adjuntara de la base de dades.",

        },
        servers: [
            {
                url: 'http://localhost:3000',
            },
        ],
    },
    apis: [ '../controllers/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);

app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Importer les rutes
const characterRoutes = require('../routes/characterRoutes');
const skinRoutes = require('../routes/skinRoutes');
const armesRoutes = require('../routes/armesRoutes');
const habilitatsRoutes = require('../routes/habilitatsRoutes');
const atacsRoutes = require('../routes/atacsRoutes');
const userRoutes = require('../routes/userRoutes');
const perfilRoutes = require('../routes/perfilroutes');



app.use('/personatges', characterRoutes);// Ruta para personajes
app.use('/skins', skinRoutes);             // Ruta para skins
app.use('/armes', armesRoutes);             // Ruta para armas
app.use('/habilitats', habilitatsRoutes);   // Ruta para habilidades legendarias
app.use('/atacs', atacsRoutes);             // Ruta para ataques
app.use('/usuaris', userRoutes);            // Ruta para usuarios
app.use('/perfils', perfilRoutes)



const port = process.env.PORT || 3000;


app.listen(port, () => {
    console.log(`Servidor escoltant al port: ${port}`);
});