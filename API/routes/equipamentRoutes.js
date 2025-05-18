const express = require('express');
const router = express.Router();
const equipamentController = require('../controllers/equipamentController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');


// Endpoint per obtenir les armes predefinides d’una skin
router.get('/skins/:skin_id/armes/:usuari_id', verificacioUsuari.verifyToken, equipamentController.getArmesPredefinidesPerSkin);

// Endpoint per equipar una arma
router.post('/equipament', verificacioUsuari.verifyToken, equipamentController.equiparArmaASkin);

module.exports = router;