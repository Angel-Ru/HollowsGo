const express = require('express');
const router = express.Router();
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta
const characterController = require('../controllers/charactersController'); // Verifica que esta ruta sea correcta


// Obtenir tots els personatges
router.get('/', verificacioUsuari.verifyToken,characterController.getPersonatges);

// Obtenir un personatge per ID
router.get('/:id', verificacioUsuari.verifyToken,characterController.getPersonatgeId);

// Obtenir un personatge per nom
router.get('/nom/:nom', verificacioUsuari.verifyToken,characterController.getPersonatgeNom);

// Afegir un nou personatge(només per admins)
router.post('/', verificacioUsuari.verifyToken,verificacioUsuari.verifyAdminDB, characterController.crearPersonatge);

//Obtenir els punts d'un enemic per nom i sumar-los a l'usuari a traves del correu
router.post('/enemics/:nom/punts', verificacioUsuari.verifyToken,characterController.obtenirPuntsEnemicISumarAUsuari);

//Borrar un personatge per ID
router.delete('/:id', verificacioUsuari.verifyToken,verificacioUsuari.verifyAdminDB, characterController.borrarPersonatgeId);

module.exports = router;
