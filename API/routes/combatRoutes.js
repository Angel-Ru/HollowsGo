const express = require('express');
const router = express.Router();
const combatController = require('../controllers/combatController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');

router.post('/combatvida', verificacioUsuari.verifyToken, combatController.updateVidaActualSkin);

module.exports = router;