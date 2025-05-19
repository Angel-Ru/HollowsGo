const express = require('express');
const router = express.Router();
const equipamentController = require('../controllers/equipamentController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');



//Endpoint per obtenir els vials de recuperació de vida que té l'usuari
router.get('/vials/:usuari_id', verificacioUsuari.verifyToken, equipamentController.getVialsUsuari);

// Endpoint per obtenir les armes predefinides d’una skin
router.get('/skins/:skin_id/armes/:usuari_id', verificacioUsuari.verifyToken, equipamentController.getArmesPredefinidesPerSkin);


// Endpoint per equipar una arma
router.post('/equipament', verificacioUsuari.verifyToken, equipamentController.equiparArmaASkin);

//Endpoint per utilitzar un vial de recuperació i recuperar la vida de l'aliat caigut o amb baixa vida
router.post('/vials', verificacioUsuari.verifyToken, equipamentController.utilitzarVial);

module.exports = router;