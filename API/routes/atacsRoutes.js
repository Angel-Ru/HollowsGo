const express = require('express');
const router = express.Router();
const atacsController = require('../controllers/atacsController');

// Obtenir l'atac d'una skin per id
router.get('/:id', atacsController.getAtacSkinPerId);

// Obtenir l'atac d'una skin per nom
router.get('/nom/:nom', atacsController.getAtacSkinPerNom);

//Crear un atac
router.post('/', atacsController.crearAtac);

//Eliminar un atac
router.delete('/:id', atacsController.borrarAtacPerId);

module.exports = router;
