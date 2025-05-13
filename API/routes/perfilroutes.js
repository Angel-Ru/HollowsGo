const express = require('express');
const router = express.Router();
const verificacioUsuari = require('../middlewares/verificacioUsuari');
const perfilController = require("../controllers/perfilController"); // Verifica que esta ruta sea correcta


// Obtenir el personatge preferit
router.get('/preferit/:id', verificacioUsuari.verifyToken, perfilController.getFavoritePersonatge());

// Actualitzar el personatge preferit
router.put('/preferit/update/:id', verificacioUsuari.verifyToken, perfilController.updateFavoritePersonatge());


module.exports = router;