const express = require('express');
const router = express.Router();
const atacsController = require('../controllers/atacsController');
const verificacioUsuari = require("../middlewares/verificacioUsuari");

// Obtenir l'atac d'una skin per id
router.get('/:id', verificacioUsuari.verifyToken,atacsController.getAtacSkinPerId);

// Obtenir l'atac d'una skin per nom
router.get('/nom/:nom', verificacioUsuari.verifyToken,atacsController.getAtacSkinPerNom);

//Crear un atac
router.post('/', verificacioUsuari.verifyToken,atacsController.crearAtac);

//Eliminar un atac
router.delete('/:id', verificacioUsuari.verifyToken,atacsController.borrarAtacPerId);

module.exports = router;
