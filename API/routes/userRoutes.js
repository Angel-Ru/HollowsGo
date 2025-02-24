const express = require('express');
const router = express.Router();
const userController = require('../controllers/usersController');
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta

// Ruta per obtenir tots els usuaris (accessible per a tots, però requereix token)
router.get('/', verificacioUsuari.verifyToken, userController.getUsuaris);

// Ruta per obtenir un usuari per ID (accessible per a tots, però requereix token)
router.get('/:id', verificacioUsuari.verifyToken, userController.getUsuariPerId);

// Ruta per obtenir els punts d'un usuari per nom (accessible per a tots, però requereix token)
router.get('/punts/:nom', verificacioUsuari.verifyToken, userController.getPuntsUsuari);

// Ruta per crear un usuari de tipus 0 (usuari normal) (accessible per a tots, no requereix token)
router.post('/', userController.crearUsuariNormalToken);

// Ruta per fer login (accessible per a tots, no requereix token)
router.post('/login', userController.login);

// Ruta per crear un usuari de tipus 1 (usuari administrador) (només accessible per a administradors)
router.post('/admin/', verificacioUsuari.verifyToken, verificacioUsuari.verifyAdminDB, userController.crearUsuariAdmin);

// Ruta per eliminar un usuari per ID (només accessible per a administradors)
router.delete('/:id', verificacioUsuari.verifyToken, verificacioUsuari.verifyAdminDB, userController.borrarUsuari);

module.exports = router;