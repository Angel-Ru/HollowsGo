const express = require('express');
const router = express.Router();
const skinsController = require('../controllers/skinsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta


//Ruta per obtenir una skin d'un enemic amb el seu mal de forma aleatoria
router.get('/enemic/', skinsController.seleccionarSkinAleatoria);

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

//Ruta per crear una skin
router.post('/', verificacioUsuari.verifyAdminDB, skinsController.crearSkin);

//Ruta per borrar una skin
router.delete('/:id', verificacioUsuari.verifyAdminDB, skinsController.borrarSkinId);


module.exports = router;
