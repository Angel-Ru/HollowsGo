const express = require('express');
const router = express.Router();
const userController = require('../controllers/usersController');

const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta

// Ruta per obtenir tots els usuaris (accessible per a tots)
router.get('/', userController.getUsuaris);

// Ruta per obtenir un usuari per ID (accessible per a tots)
router.get('/:id', userController.getUsuariPerId);


// Ruta per obtenir els punts d'un usuari per nom (accessible per a tots)
router.get('/punts/:nom', userController.getPuntsUsuari);

// Ruta per crear un usuari de tipus 0 (usuari normal) (accessible per a tots)
router.post('/', userController.crearUsuariNormal);

// Ruta per fer login (accessible per a tots)
router.post('/login', userController.login);

// Ruta per crear un usuari de tipus 1 (usuari administrador) (només accessible per a administradors)
router.post('/admin/', verificacioUsuari.verifyAdminDB, userController.crearUsuariAdmin);

// Ruta per eliminar un usuari per ID (només accessible per a administradors)
router.delete('/:id', verificacioUsuari.verifyAdminDB, userController.borrarUsuari);



module.exports = router;
