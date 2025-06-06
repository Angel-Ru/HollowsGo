const express = require('express');
const router = express.Router();
const skinsController = require('../controllers/skinsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta




//Ruta per obtenir tots els personatges amb les seves skins de l'usuari
router.get('/biblioteca/:id', verificacioUsuari.verifyToken,skinsController.getPersonatgesAmbSkinsPerUsuari);

router.post('/skindia', verificacioUsuari.verifyToken, skinsController.skinDelDia)

router.post('/skindia/comprar', verificacioUsuari.verifyToken, skinsController.comprarSkin)

// Ruta per obtenir tots els quincys amb les seves skins de l'usuari
router.get('/biblioteca/quincys/:id',skinsController.getPersonatgesAmbSkinsPerUsuariQuincy);

//Ruta per obtenir tots els enemics amb les seves skins de l'usuari
router.get('/biblioteca/enemics/:id',skinsController.getPersonatgesAmbSkinsPerUsuariEnemics);

router.get('/fragments/:nom', verificacioUsuari.verifyToken, skinsController.getFragmentsSkinsUsuari);

//Ruta per obtenir una skin d'un enemic amb el seu mal de forma aleatoria
router.get('/enemic/', verificacioUsuari.verifyToken,skinsController.seleccionarSkinAleatoria);

//Ruta per obtenir una skin d'un enemic amb el seu mal de forma aleatoria
router.get('/enemic/personatges', verificacioUsuari.verifyToken,skinsController.getPersonatgesEnemicsAmbSkins);

// Ruta per obtenir totes les skins d'un personatge
router.get('/:id', verificacioUsuari.verifyToken,skinsController.getSkinsPersonatge);

// Ruta per obtenir una skin específica d'un personatge d'un usuari per ID
router.get('/usuari/:id/:skin_id', verificacioUsuari.verifyToken,skinsController.getSkinUsuariPerId);

// Ruta per obtenir una skin específica per nom d'un personatge d'un usuari per id
router.get('/usuari/:id/nom/:nom', verificacioUsuari.verifyToken,skinsController.getSkinPerNomUsuariPerId);



// Ruta per a la tirada de gacha
router.post('/gacha',verificacioUsuari.verifyToken, skinsController.gachaTirada);  // Eliminat el :userId i ara rebem l'email en el cos de la petició

router.post('/gacha/simulacio', verificacioUsuari.verifyToken, skinsController.gachaSimulacio)

// Ruta per a la tirada de gacha dels quincys
router.post('/gacha/quincys', verificacioUsuari.verifyToken, skinsController.gachaTiradaQuincy);

//Ruta per a la tirada de gacha dels enemics
router.post('/gacha/enemics', verificacioUsuari.verifyToken, skinsController.gachaTiradaEnemics);

//Ruta per tirar una multi al banner de shinigamis
router.post('/gacha/multish', verificacioUsuari.verifyToken, skinsController.gachaMultiSH);

//Ruta per tirar una multi al banner de quincys
router.post('/gacha/multiqu', verificacioUsuari.verifyToken, skinsController.gachaMultiQU);

//Ruta per tirar una multi al banner de enemics
router.post('/gacha/multiho', verificacioUsuari.verifyToken, skinsController.gachaMultiHO);


//Ruta per crear una skin
router.post('/', verificacioUsuari.verifyToken,verificacioUsuari.verifyAdminDB, skinsController.crearSkin);

//Ruta per borrar una skin
router.delete('/:id', verificacioUsuari.verifyToken, verificacioUsuari.verifyAdminDB, skinsController.borrarSkinId);

// Ruta per obtenir skin seleccionada
router.get('/seleccionada/:id', verificacioUsuari.verifyToken, skinsController.getSkinSeleccionada);

// Ruta per actualitzar la skin seleccionada
router.put('/seleccionada/actuliatzar/:id', verificacioUsuari.verifyToken, skinsController.updateSkinSeleccionada);

// Ruta per llevar la skin seleccionada
router.put('/seleccionada/llevar/:id', verificacioUsuari.verifyToken, skinsController.llevarSkinSeleccionada);

module.exports = router;
