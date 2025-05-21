const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Habilitats
 *   description: Operacions relacionades amb les habilitats llegendàries
 */

/**
 * @swagger
 * /habilitats/{id}:
 *   get:
 *     tags: [Habilitats]
 *     summary: Obtenir la habilitat llegendària d'una skin per ID
 *     description: Retorna la habilitat llegendària associada a una skin específica mitjançant el seu ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de la skin
 *     responses:
 *       200:
 *         description: Detalls de la habilitat de la skin
 *       404:
 *         description: No s'ha trobat la habilitat per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getHabilitatId = async (req, res) => {
    try {
        const { id } = req.params;

        const pool = await connectDB();
        const [rows] = await pool.execute(`
            SELECT h.*
            FROM HABILITAT_LLEGENDARIA h
                     JOIN SKINS s ON h.skin_personatge = s.id
            WHERE s.id = ?
        `, [id]);

        res.send(rows.length > 0 ? rows : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /habilitats/{skin_nom}:
 *   get:
 *     tags: [Habilitats]
 *     summary: Obtenir la habilitat llegendària d'una skin per nom
 *     description: Retorna la habilitat llegendària associada a una skin específica mitjançant el seu nom.
 *     parameters:
 *       - in: path
 *         name: nom
 *         required: true
 *         schema:
 *           type: string
 *         description: Nom de la skin
 *     responses:
 *       200:
 *         description: Detalls de la habilitat de la skin
 *       404:
 *         description: No s'ha trobat la habilitat per a aquesta skin
 *       500:
 *         description: Error en la consulta
 */
exports.getHabilitatSkinNom = async (req, res) => {
    try {
        const { nom } = req.params;

        const pool = await connectDB(); // conexión MySQL
        const [rows] = await pool.execute(`
            SELECT h.*
            FROM HABILITAT_LLEGENDARIA h
                     JOIN SKINS s ON h.skin_personatge = s.id
            WHERE s.nom = ?
        `, [nom]);

        res.send(rows.length > 0 ? rows : 'No s\'ha trobat la habilitat per a aquesta skin');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /habilitats/:
 *   post:
 *     tags: [Habilitats]
 *     summary: Crear una nova habilitat.
 *     description: |
 *       Afegeix una nova habilitat a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "exemple@gmail.com"
 *         "nom": "Bola de Foc",
 *         "descripcio": "Llança una bola de foc que crema als enemics.",
 *         "video": "https://exemple.com/video",
 *         "musica_combat": "https://exemple.com/musica",
 *         "skin_personatge": 1
 *       }
 *       ```
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - nom
 *               - descripcio
 *               - video
 *               - musica_combat
 *               - skin_personatge
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom de l'habilitat.
 *                 example: "Bola de Foc"
 *               descripcio:
 *                 type: string
 *                 description: Descripció de l'habilitat.
 *                 example: "Llança una bola de foc que crema als enemics."
 *               video:
 *                 type: string
 *                 description: Enllaç al vídeo de l'habilitat.
 *                 example: "https://exemple.com/video"
 *               musica_combat:
 *                 type: string
 *                 description: Enllaç a la música de combat de l'habilitat.
 *                 example: "https://exemple.com/musica"
 *               skin_personatge:
 *                 type: integer
 *                 description: ID de la skin associada a l'habilitat.
 *                 example: 1
 *     responses:
 *       201:
 *         description: Habilitat afegida correctament.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   example: "Habilitat afegida correctament."
 *       500:
 *         description: Error en inserir l'habilitat.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Error en inserir l'habilitat."
 */
exports.crearHabilitat = async (req, res) => {
    try {
        const { nom, descripcio, video, musica_combat, skin_personatge } = req.body;

        // Validación básica
        if (!nom || !descripcio || !video || !musica_combat || !skin_personatge) {
            return res.status(400).json({ error: "Falten dades obligatòries." });
        }

        const pool = await connectDB();
        await pool.execute(`
            INSERT INTO HABILITAT_LLEGENDARIA (nom, descripcio, video, musica_combat, skin_personatge)
            VALUES (?, ?, ?, ?, ?)
        `, [nom, descripcio, video, musica_combat, skin_personatge]);

        res.status(201).json({ message: "Habilitat afegida correctament." });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Error en inserir l'habilitat." });
    }
};


/**
 * @swagger
 * /habilitats/{id}:
 *   delete:
 *     tags: [Habilitats]
 *     summary: Eliminar una habilitat per ID
 *     description: |
 *       Elimina una habilitat de la base de dades mitjançant el seu ID.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: ID de l'habilitat a eliminar
 *     responses:
 *       200:
 *         description: Habilitat eliminada correctament
 *       404:
 *         description: Habilitat no trobada
 *       500:
 *         description: Error en eliminar l'habilitat
 */
exports.borrarHabilitatId = async (req, res) => {
    try {
        const { id } = req.params;

        const pool = await connectDB();
        const [result] = await pool.execute(
            'DELETE FROM HABILITAT_LLEGENDARIA WHERE id = ?',
            [id]
        );

        if (result.affectedRows === 0) {
            return res.status(404).send('Habilitat no trobada');
        }

        res.send('Habilitat eliminada correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en eliminar l'habilitat");
    }
};


// Cercar una habilitat pel personatge
exports.getHabilitatPersonatge = async (req, res) => {
    const personatgeId = req.params.personatgeId;

    try {
        const [rows] = await db.execute(`
      SELECT h.id, h.nom, h.descripcio, h.video, h.musica_combat
      FROM HABILITAT_LLEGENDARIA h
      INNER JOIN SKINS s ON h.skin_personatge = s.id
      WHERE s.personatge = ?
      LIMIT 1;
    `, [personatgeId]);

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Aquest personatge no té habilitat llegendària.' });
        }

        res.json(rows[0]);

    } catch (error) {
        console.error('Error consultant habilitat:', error);
        res.status(500).json({ message: 'Error del servidor' });
    }
};
