const express = require('express');
const router = express.Router();
const missionsController = require('../controllers/missionsController');
const verificacioUsuari = require('../middlewares/verificacioUsuari');



router.get('/titol/:usuariId', verificacioUsuari.verifyToken, missionsController.getMissionTitol)

// Ruta per assignar missions diaries a un usuari per id
router.post('/diaries/:usuariId', verificacioUsuari.verifyToken, missionsController.assignarMissionsDiaries);

router.put('/progres/incrementa/:id', verificacioUsuari.verifyToken, missionsController.incrementarProgresMissio);

router.post('/titols/:usuariId', verificacioUsuari.verifyToken, missionsController.assignarMissionsTitols);

router.patch('/titol/progres/incrementa/:usuariId', verificacioUsuari.verifyToken, missionsController.incrementarProgresTitol);


module.exports = router;