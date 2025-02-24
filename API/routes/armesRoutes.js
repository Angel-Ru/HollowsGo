const express = require('express');
const router = express.Router();
const armesController = require('../controllers/armesController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');

// Obtenir totes les armes d'una skin
router.get('/:id', verificacioUsuari.verifyToken,armesController.getArmesPerSkinId);

// Obtenir totes les armes d'una skin per nom
router.get('/nom/:nom', verificacioUsuari.verifyToken,armesController.getArmesPerSkinNom);

// Obtenir una arma d'una skin per id
router.get('/:id/:arma_id', verificacioUsuari.verifyToken,armesController.getArmaSkinId);

// Obtenir una arma per nom d'una skin per nom
router.get('/nom/:nom/:arma_nom', verificacioUsuari.verifyToken,armesController.getArmaSkinNom);

// Crear una arma per a una skin
router.post('/', verificacioUsuari.verifyToken,armesController.crearArma);

// Borrar arma per id
router.delete('/:id', verificacioUsuari.verifyToken,armesController.borrarArmaPerId);

module.exports = router;
