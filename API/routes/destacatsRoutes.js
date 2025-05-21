const express = require('express');
const router = express.Router();
const destacatsController = require('../controllers/destacatsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');

// Obtenir les skins destacades de els aliats
router.get('/shinigamis', verificacioUsuari.verifyToken,destacatsController.getSkinsCategoria4Raça1);

router.get('/quincy', verificacioUsuari.verifyToken,destacatsController.getSkinsCategoria4Raça0);

module.exports = router;