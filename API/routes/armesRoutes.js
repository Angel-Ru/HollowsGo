const express = require('express');
const router = express.Router();
const armesController = require('../controllers/armesController');

// Obtenir totes les armes d'una skin
router.get('/:id', armesController.getArmesPerSkinId);

// Obtenir totes les armes d'una skin per nom
router.get('/nom/:nom', armesController.getArmesPerSkinNom);

// Obtenir una arma d'una skin per id
router.get('/:id/:arma_id', armesController.getArmaSkinId);

// Obtenir una arma per nom d'una skin per nom
router.get('/nom/:nom/:arma_nom', armesController.getArmaSkinNom);

module.exports = router;
