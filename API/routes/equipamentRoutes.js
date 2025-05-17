const express = require('express');
const router = express.Router();
const userController = require('../controllers/usersController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');


// Ruta per obtenir les armes predefinides per a una skin
router.get('/armes/:skin_id', verificacioUsuari.verifyToken, userController.getArmesPredefinidesPerSkin);

// Ruta per equipar una arma a una skin
router.post('/equipar', verificacioUsuari.verifyToken, userController.equiparArmaASkin);