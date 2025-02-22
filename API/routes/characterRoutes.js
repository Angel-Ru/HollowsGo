const express = require('express');
const router = express.Router();
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta
const characterController = require('../controllers/charactersController'); // Verifica que esta ruta sea correcta


// Obtenir tots els personatges
router.get('/', characterController.getPersonatges);

// Obtenir un personatge per ID
router.get('/:id', characterController.getPersonatgeId);

// Obtenir un personatge per nom
router.get('/nom/:nom', characterController.getPersonatgeNom);

// Afegir un nou personatge(només per admins)
router.post('/', verificacioUsuari.verifyAdminDB, characterController.crearPersonatge);

//Obtenir els punts d'un enemic per nom i sumar-los a l'usuari a traves del correu
router.post('/enemics/:nom/punts', characterController.obtenirPuntsEnemicISumarAUsuari);

//Borrar un personatge per ID
router.delete('/:id', verificacioUsuari.verifyAdminDB, characterController.borrarPersonatgeId);

module.exports = router;
