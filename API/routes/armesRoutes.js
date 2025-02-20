const express = require('express');
const router = express.Router();
const armesController = require('../controllers/armesController');

// Obtenir totes les armes d'una skin
router.get('/:id', armesController.getArmsBySkinId);

// Obtenir totes les armes d'una skin per nom
router.get('/nom/:nom', armesController.getArmsBySkinName);

// Obtenir una arma d'una skin per id
router.get('/:id/:arma_id', armesController.getArmById);

// Obtenir una arma per nom d'una skin per nom
router.get('/nom/:nom/:arma_nom', armesController.getArmByName);

module.exports = router;
