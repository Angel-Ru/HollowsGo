const express = require('express');
const router = express.Router();
const destacatsController = require('../controllers/destacatsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta

// Obtenir la habilitat llegendaria d'una skin per id
router.get('/shinigamis', verificacioUsuari.verifyToken,destacatsController.getSkinsCategoria4Raça1);

module.exports = router;