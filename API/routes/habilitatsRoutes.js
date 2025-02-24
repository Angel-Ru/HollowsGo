const express = require('express');
const router = express.Router();
const habilitatsController = require('../controllers/habilitatsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari'); // Verifica que esta ruta sea correcta

// Obtenir la habilitat llegendaria d'una skin per id
router.get('/:id', verificacioUsuari.verifyToken,habilitatsController.getHabilitatId);

// Obtenir la habilitat llegendaria d'una skin per nom
router.get('/nom/:nom', verificacioUsuari.verifyToken,habilitatsController.getHabilitatSkinNom);

//Crear una nova habilitat
router.post('/', verificacioUsuari.verifyToken,verificacioUsuari.verifyAdminDB, habilitatsController.crearHabilitat);

//Eliminar una habilitat per id
router.delete('/:id', verificacioUsuari.verifyToken,verificacioUsuari.verifyAdminDB, habilitatsController.borrarHabilitatId);

module.exports = router;
