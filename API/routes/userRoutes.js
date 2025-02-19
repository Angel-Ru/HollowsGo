const express = require('express');
const router = express.Router();
const { getUsers, getUserById, createUser, deleteUser, createUserType0, createUserAdminProtegit, login} = require('../controllers/usersController');
const { verifyAdmin } = require('../middlewares/verificacioUsuari');  // Importem el middleware de verificació d'administrador

// Ruta per obtenir tots els usuaris (accessible per a tots)
router.get('/', getUsers);

// Ruta per obtenir un usuari per ID (accessible per a tots)
router.get('/:id', getUserById);

// Ruta per crear un nou usuari (només accessible per a administradors)
router.post('/', createUserType0);

router.post('/login', login);

router.post('/admin', createUserAdminProtegit);

// Ruta per eliminar un usuari per ID (només accessible per a administradors)
router.delete('/:id', deleteUser);

module.exports = router;
