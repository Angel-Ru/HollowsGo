const express = require('express');
const router = express.Router();
const verificacioUsuari = require('../middlewares/verificacioUsuari');
const perfilController = require("../controllers/perfilController");


// Obtenir el personatge preferit
router.get('/preferit/:userId', verificacioUsuari.verifyToken, perfilController.getFavoritePersonatge);

// Actualitzar el personatge preferit
router.put('/preferit/update/:userId', verificacioUsuari.verifyToken, perfilController.updateFavoritePersonatge);

// Actualitzar l'skin preferida
router.put('/skin/update/:userId', verificacioUsuari.verifyToken, perfilController.updateFavoriteSkin);

// Obtenir tot lo de l'exp de l'usuari
router.get('/exp/:userId', verificacioUsuari.verifyToken, perfilController.getallExp);

router.get('/titols/:usuariId', verificacioUsuari.verifyToken, perfilController.getTitolsComplets)

router.get('titol/:usuariId', verificacioUsuari.verifyToken, perfilController.perfilController)

module.exports = router;