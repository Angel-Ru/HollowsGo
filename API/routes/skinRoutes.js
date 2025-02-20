const express = require('express');
const router = express.Router();
const skinsController = require('../controllers/skinsController');

// Ruta per obtenir totes les skins d'un personatge
router.get('/:id', skinsController.getSkinsByCharacter);

// Ruta per obtenir totes les skins d'un personatge que té un usuari
router.get('/usuari/:id', skinsController.getSkinsByUser);

// Ruta per obtenir una skin específica d'un personatge d'un usuari per ID
router.get('/usuari/:id/:skin_id', skinsController.getSkinByUserAndId);

// Ruta per obtenir una skin específica d'un personatge d'un usuari per nom
router.get('/usuari/:id/nom/:nom', skinsController.getSkinByUserAndName);

module.exports = router;
