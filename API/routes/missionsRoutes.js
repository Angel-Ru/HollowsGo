const express = require('express');
const router = express.Router();
const missionsController = require('../controllers/missionsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');



// Ruta per assignar missions diaries a un usuari per id
router.post('/diaries/:usuariId', verificacioUsuari.verifyToken, missionsController.assignarMissionsDiaries);

router.put('/progres/incrementa/:id', missionsController.incrementarProgresMissio);


module.exports = router;