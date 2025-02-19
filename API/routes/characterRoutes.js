const express = require('express');
const router = express.Router();
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta
const characterController = require('../controllers/charactersController'); // Verifica que esta ruta sea correcta


// Obtenir tots els personatges
router.get('/', characterController.getAllCharacters);

// Obtenir un personatge per ID
router.get('/:id', characterController.getCharacterById);

// Obtenir un personatge per nom
router.get('/nom/:nom', characterController.getCharacterByName);

// Afegir un nou personatge
router.post('/', verificacioUsuari.verifyAdminDB, characterController.createCharacter);

module.exports = router;
