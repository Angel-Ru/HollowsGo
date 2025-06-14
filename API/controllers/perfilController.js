const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Perfil
 *   description: Endpoints per gestionar el perfil de l'usuari.
 */

/**
 * @swagger
 * /perfil_usuari/preferit/{userId}:
 *   get:
 *     summary: Obtenir el personatge i skin preferits d'un usuari
 *     description: Retorna el personatge i el skin preferits d'un usuari específic.
 *     tags: [Perfil_Usuari
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         description: ID de l'usuari
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Informació del personatge i skin preferits de l'usuari
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 userId:
 *                   type: integer
 *                 personatge_preferit:
 *                   type: string
 *                 skin_preferida:
 *                   type: string
 *       404:
 *         description: Usuari no trobat
 *       500:
 *         description: Error en la consulta
 */
exports.getFavoritePersonatge = async (req, res) => {
    try {
        const { userId } = req.params;
        const connection = await connectDB();

        const [rows] = await connection.execute(
            `SELECT 
                p.personatge_preferit, 
                per.nom, 
                p.skin_preferida_id, 
                s.imatge 
             FROM PERFIL_USUARI p
             JOIN SKINS s ON s.id = p.skin_preferida_id
             JOIN PERSONATGES per ON per.id = p.personatge_preferit
             WHERE p.usuari = ?`,
            [userId]
        );

        if (rows.length === 0) {
            return res.status(404).send('Usuari no trobat');
        }

        const { personatge_preferit, skin_preferida_id, nom, imatge } = rows[0];

        res.send({
            userId,
            personatge_preferit: personatge_preferit || null,
            skin_preferida_id: skin_preferida_id || null,
            nom: nom || null,
            imatge: imatge || null
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};



/**
 * @swagger
 * /perfil_usuari/preferit/{userId}:
 *   put:
 *     summary: Actualitzar el personatge i skin preferits d'un usuari
 *     description: Actualitza el personatge i el skin preferits d'un usuari.
 *     tags: [perfil_usuari]
 *     parameters:
 *       - in: path
 *         name: userId
 *         required: true
 *         description: ID de l'usuari
 *         schema:
 *           type: integer
 *       - in: body
 *         name: body
 *         required: true
 *         description: Dades per actualitzar el personatge i skin preferits
 *         schema:
 *           type: object
 *           properties:
 *             personatge_preferit:
 *               type: string
 *             skin_preferida:
 *               type: string
 *     responses:
 *       200:
 *         description: Personatge i skin preferits actualitzats correctament
 *       400:
 *         description: Dades incorrectes
 *       404:
 *         description: Usuari no trobat
 *       500:
 *         description: Error en la consulta
 */
exports.updateFavoritePersonatge = async (req, res) => {
    try {
        const { userId } = req.params;
        const { personatge_preferit } = req.body;

        if (!personatge_preferit) {
            return res.status(400).send('Dades incorrectes: Personatge preferit mancant');
        }

        const connection = await connectDB();
        const [result] = await connection.execute(
            `UPDATE PERFIL_USUARI
             SET personatge_preferit = ?
             WHERE usuari = ?`,
            [personatge_preferit, userId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).send('Usuari no trobat');
        }
        console.log(result);
        res.send('Personatge preferit actualitzat correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


exports.updateFavoriteSkin = async (req, res) => {
    try {
        const { userId } = req.params;
        const { skin_preferida_id } = req.body;

        if (!skin_preferida_id) {
            return res.status(400).send('Dades incorrectes: Skin preferida mancant');
        }

        const connection = await connectDB();
        const [result] = await connection.execute(
            `UPDATE PERFIL_USUARI
             SET skin_preferida_id = ?
             WHERE usuari = ?`,
            [skin_preferida_id, userId]
        );

        if (result.affectedRows === 0) {
            return res.status(404).send('Usuari no trobat');
        }
        console.log(result);
        res.send('Skin preferida actualitzada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

// Endpoint per obtenir el nivel d'un usuari, l'exp_maxima i l'exp_emmagatzamada
exports.getallExp = async (req, res) => {
    try {
        const { userId } = req.params;
        const connection = await connectDB();

        const [rows] = await connection.execute(
            `SELECT 
                p.nivell, 
                p.exp_max, 
                p.exp_emmagatzemada 
             FROM USUARIS p
             WHERE p.id = ?`,
            [userId]
        );

        if (rows.length === 0) {
            return res.status(404).send('Usuari no trobat');
        }

        const { nivell, exp_max, exp_emmagatzemada } = rows[0];

        res.send({
            userId,
            nivell: nivell || null,
            exp_max: exp_max || null,
            exp_emmagatzemada: exp_emmagatzemada || null
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
}

exports.getTitolsComplets = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari invàlid' });
  }

  try {
    const connection = await connectDB();

    // 🔎 Obtenim tots els títols amb missions completades de tipus 1 per l’usuari
    const [titolsCompletats] = await connection.execute(`
      SELECT DISTINCT
        t.id AS titol_id,
        t.nom_titol
      FROM MISSIONS_TITOLS mt
      JOIN USUARIS_MISSIONS um ON mt.usuaris_missions_id = um.id
      JOIN MISSIONS m ON mt.missio_id = m.id
      JOIN TITOLS t ON mt.titol_id = t.id
      WHERE um.usuari_id = ?
        AND m.tipus_missio = 1
        AND um.progres >= m.objectiu
    `, [usuariId]);

    if (titolsCompletats.length === 0) {
      return res.status(200).json({
        missatge: 'No hi ha títols amb missions completades per aquest usuari.',
        titols: []
      });
    }

    res.status(200).json({
      missatge: 'Títols amb missions completades recuperats correctament',
      titols: titolsCompletats
    });

  } catch (err) {
    console.error('Error recuperant títols amb missions completades:', err.message);
    res.status(500).json({ error: 'Error intern del servidor' });
  }
};


exports.getTitolUsuari = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  if (!usuariId) {
    return res.status(400).json({ error: 'Usuari invàlid' });
  }

  try {
    const connection = await connectDB();

    // 🔎 Obtenir el titol_id de la taula PERFIL_USUARI
    const [rows] = await connection.execute(`
      SELECT titol
      FROM PERFIL_USUARI
      WHERE usuari = ?
    `, [usuariId]);

    if (rows.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' });
    }

    const titolId = rows[0].titol;

    if (!titolId) {
      return res.status(200).json({
        missatge: 'L’usuari no té cap títol assignat',
        titol: null
      });
    }

    // 🔎 Obtenir més informació del títol
    const [titolData] = await connection.execute(`
      SELECT id AS titol_id, nom_titol
      FROM TITOLS
      WHERE id = ?
    `, [titolId]);

    if (titolData.length === 0) {
      return res.status(404).json({ error: 'Títol no trobat' });
    }

    // ✅ Resposta
    res.status(200).json({
      missatge: 'Títol de l’usuari recuperat correctament',
      titol: titolData[0]
    });

  } catch (err) {
    console.error('Error recuperant títol de l’usuari:', err.message);
    res.status(500).json({ error: 'Error intern del servidor' });
  }
};

  
exports.actualitzarTitolUsuari = async (req, res) => {
  const usuariId = parseInt(req.params.usuariId);
  const { titolId } = req.body;

  if (!usuariId || !titolId) {
    return res.status(400).json({ error: 'Usuari o títol invàlid' });
  }

  try {
    const connection = await connectDB();

    // Comprovar que l'usuari existeix
    const [usuariRows] = await connection.execute(`
      SELECT * FROM PERFIL_USUARI WHERE usuari = ?
    `, [usuariId]);

    if (usuariRows.length === 0) {
      return res.status(404).json({ error: 'Usuari no trobat' });
    }

    // Comprovar que el títol existeix
    const [titolRows] = await connection.execute(`
      SELECT * FROM TITOLS WHERE id = ?
    `, [titolId]);

    if (titolRows.length === 0) {
      return res.status(404).json({ error: 'Títol no trobat' });
    }

    // Actualitzar només el títol
    await connection.execute(`
      UPDATE PERFIL_USUARI
      SET titol = ?
      WHERE usuari = ?
    `, [titolId, usuariId]);

    res.status(200).json({ missatge: 'Títol actualitzat correctament' });

  } catch (err) {
    console.error('Error al patch del títol:', err.message);
    res.status(500).json({ error: 'Error intern del servidor' });
  }
};


