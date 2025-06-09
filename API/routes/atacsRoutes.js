const express = require('express');
const router = express.Router();
const { param, body, validationResult } = require('express-validator');
const atacsController = require('../controllers/atacsController');
const verificacioUsuari = require("../middlewares/verificacioUsuari");

// Middleware per gestionar errors de validació
const validarErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });
  next();
};

// Obtenir l'atac d'una skin per id
router.get('/:id',
  
  param('id').isInt().withMessage('ID ha de ser un número enter'),
  validarErrors,
  atacsController.getAtacSkinPerId
);

// Obtenir l'atac d'una skin per nom
router.get('/nom/:nom',
  verificacioUsuari.verifyToken,
  param('nom').trim().notEmpty().escape().withMessage('El nom és obligatori'),
  validarErrors,
  atacsController.getAtacSkinPerNom
);

// Crear un atac
router.post('/',
  verificacioUsuari.verifyToken,
  body('nom').trim().notEmpty().escape().withMessage('El nom és obligatori'),
  body('mal').isInt({ min: 1 }).withMessage('El mal ha de ser un número positiu'),
  validarErrors,
  atacsController.crearAtac
);

// Eliminar un atac
router.delete('/:id',
  verificacioUsuari.verifyToken,
  param('id').isInt().withMessage('ID ha de ser un número enter'),
  validarErrors,
  atacsController.borrarAtacPerId
);

module.exports = router;
