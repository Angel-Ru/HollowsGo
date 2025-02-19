const express = require('express');
const router = express.Router();
const habilitatsController = require('../controllers/habilitatsController');

// Obtenir la habilitat llegendaria d'una skin per id
router.get('/:id', habilitatsController.getLegendaryAbilityBySkinId);

// Obtenir la habilitat llegendaria d'una skin per nom
router.get('/nom/:nom', habilitatsController.getLegendaryAbilityBySkinName);

module.exports = router;
