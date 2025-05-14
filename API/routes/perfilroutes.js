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


module.exports = router;