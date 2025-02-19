const express = require('express');
const router = express.Router();
const atacsController = require('../controllers/atacsController');

// Obtenir l'atac d'una skin per id
router.get('/:id', atacsController.getAttackBySkinId);

// Obtenir l'atac d'una skin per nom
router.get('/nom/:nom', atacsController.getAttackBySkinName);

module.exports = router;
