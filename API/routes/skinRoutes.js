const express = require('express');
const router = express.Router();
const skinsController = require('../controllers/skinsController');

// Ruta per obtenir totes les skins d'un personatge
router.get('/:id', skinsController.getSkinsPersonatge);

// Ruta per obtenir totes les skins d'un personatge que té un usuari
router.get('/usuari/:id', skinsController.getSkinsUsuari);

// Ruta per obtenir una skin específica d'un personatge d'un usuari per ID
router.get('/usuari/:id/:skin_id', skinsController.getSkinUsuariPerId);

// Ruta per obtenir una skin específica per nom d'un personatge d'un usuari per id
router.get('/usuari/:id/nom/:nom', skinsController.getSkinPerNomUsuariPerId);

// Ruta per a la tirada de gacha
router.post('/gacha', skinsController.gachaTirada);  // Eliminat el :userId i ara rebem l'email en el cos de la petició

module.exports = router;
