const express = require('express');
const router = express.Router();
const userController = require('../controllers/usersController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');

// Ruta per obtenir tots els usuaris (accessible per a tots, però requereix token)
router.get('/', verificacioUsuari.verifyToken, userController.getUsuaris);

// Ruta per obtenir les dades del perfil d'usuari
router.get('/perfil/:id', verificacioUsuari.verifyToken, userController.mostrarDadesPerfil);

// Ruta per obtenir els punts d'un usuari per nom (accessible per a tots, però requereix token)
router.get('/punts/:nom', verificacioUsuari.verifyToken, userController.getPuntsUsuari);

// Ruta per sumar els punts comprats per un usuari
router.put('/punts/comprats/:id/:punts',verificacioUsuari.verifyToken, userController.sumarPuntsUsuari);

// Ruta per obtenir els avatars
router.get('/avatars', verificacioUsuari.verifyToken, userController.llistarAvatars);

//Ruta per obtenir el avatar de l'usuari
router.get('/avatar/:id', verificacioUsuari.verifyToken, userController.obtenirAvatar);

// Ruta per obtenir un usuari per ID (aquesta ha d'anar al final!)
router.get('/:id', verificacioUsuari.verifyToken, userController.getUsuariPerId);

// Ruta per crear un usuari de tipus 0 (usuari normal) (accessible per a tots, no requereix token)
router.post('/', userController.crearUsuariNormalToken);

// Ruta per fer login (accessible per a tots, no requereix token)
router.post('/login', userController.login);

// Ruta per crear un usuari de tipus 1 (usuari administrador) (només accessible per a administradors)
router.post('/admin/', verificacioUsuari.verifyToken, verificacioUsuari.verifyAdminDB, userController.crearUsuariAdmin);

// Ruta per eliminar un usuari per ID (només accessible per a administradors)
router.delete('/:id', verificacioUsuari.verifyToken, userController.borrarUsuari);

//Ruta per modificar la imatge de perfil de l'usuari
router.put('/actualitzaravatar', verificacioUsuari.verifyToken, userController.actualitzarAvatar);

// Ruta per modificar el nom d'un usuari (només accessible per a l'usuari), ja que ha de posar la seva contrasenya actual.
router.put('/nom', verificacioUsuari.verifyToken, userController.modificarNomUsuari);

//Ruta perquè l'usuari pugui modificar la seva contrasenya, però només si posa la seva actual i coincideix amb la que ja tenia.
router.put('/contrasenya', verificacioUsuari.verifyToken, userController.modificarContrasenyaUsuari);

//Ruta per sumar una partida guanyada al perfil d'usuari
router.put('/partida_guanyada/:id', verificacioUsuari.verifyToken, userController.sumartPartidaGuanyada);

//Ruta per sumar una partida jugada al perfil d'usuari
router.put('/partida_jugada/:id', verificacioUsuari.verifyToken, userController.sumarPartidaJugada);

// Ruta per obtenir totes les amistats d'un usuari
router.get('/amics/:id', verificacioUsuari.verifyToken, userController.obtenirAmistats);

router.get('/perfil/:id/amic/:idUsuariLoguejat', userController.obtenirEstadistiquesAmic);

// Ruta per veure les sol·licituds pendents d'un usuari
router.put('/amics/:id/pendents', verificacioUsuari.verifyToken, userController.obtenirpendents);

// Ruta per afegir un amic
router.post('/amics/nova/:id', verificacioUsuari.verifyToken, userController.crearamistat);

module.exports = router;