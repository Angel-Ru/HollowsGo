const express = require('express');
const router = express.Router();
const combatController = require('../controllers/combatController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');

// Obtenir la vida_actual d'una skin per un usuari
router.get('/vida/:id', verificacioUsuari.verifyToken, combatController.getVidaActualSkin);

// Actualitzar la vida_actual d'una skin per un usuari
router.put('/vida/:id', verificacioUsuari.verifyToken, combatController.updateVidaActualSkin);

module.exports = router;