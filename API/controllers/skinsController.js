const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Skins
 *   description: Operacions relacionades amb les skins dels personatges
 */


/**
 * @swagger
 * /skins/{personatge_id}:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir totes les skins d'un personatge
 *     description: Aquesta API retorna totes les skins d'un personatge basat en l'ID del personatge.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID del personatge per obtenir les seves skins.
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Llista de skins trobades per al personatge.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: integer
 *                   nom:
 *                     type: string
 *       404:
 *         description: No s'han trobat skins per al personatge.
 *       500:
 *         description: Error en la consulta.
 */
exports.getSkinsPersonatge = async (req, res) => {
    try {
        const connection = await connectDB();
        const [rows] = await connection.execute(`
            SELECT s.*
            FROM SKINS s
            JOIN PERSONATGES p ON s.personatge = p.id
            WHERE p.id = ?
        `, [req.params.id]);

        if (rows.length > 0) {
            res.send(rows);
        } else {
            res.send("No s'han trobat skins per a aquest personatge");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /skins/usuari/{user_id}/{skin_id}:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir una skin específica d'un personatge per ID d'usuari, per comprovar si l'usuari té aquesta skin.
 *     description: Aquesta API retorna una skin específica d'un personatge per un usuari determinat mitjançant els seus IDs.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID de l'usuari.
 *         schema:
 *           type: integer
 *       - name: skin_id
 *         in: path
 *         required: true
 *         description: ID de la skin.
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: La skin trobada per aquest usuari.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *       404:
 *         description: No s'ha trobat la skin per a aquest usuari.
 *       500:
 *         description: Error en la consulta.
 */
exports.getSkinUsuariPerId = async (req, res) => {
    try {
        const connection = await connectDB();
        const [rows] = await connection.execute(`
            SELECT s.*
            FROM SKINS s
            JOIN PERSONATGES p ON s.personatge = p.id
            JOIN BIBLIOTECA b ON p.id = b.personatge_id
            JOIN USUARIS u ON b.user_id = u.id
            WHERE u.id = ? AND s.id = ?
        `, [req.params.id, req.params.skin_id]);

        if (rows.length > 0) {
            res.send(rows);
        } else {
            res.send("No s'ha trobat la skin per a aquest usuari");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /skins/usuari/{id}/nom/{skin_nom}:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir una skin per nom d'un personatge per usuari
 *     description: Aquesta API permet obtenir una skin per nom per un usuari i personatge determinat.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID de l'usuari.
 *         schema:
 *           type: integer
 *       - name: nom
 *         in: path
 *         required: true
 *         description: Nom de la skin.
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: La skin trobada per aquest usuari.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *       404:
 *         description: No s'ha trobat la skin per a aquest usuari.
 *       500:
 *         description: Error en la consulta.
 */
exports.getSkinPerNomUsuariPerId = async (req, res) => {
    try {
        const connection = await connectDB();
        const [rows] = await connection.execute(`
            SELECT s.*
            FROM SKINS s
            JOIN PERSONATGES p ON s.personatge = p.id
            JOIN BIBLIOTECA b ON p.id = b.personatge_id
            JOIN USUARIS u ON b.user_id = u.id
            WHERE u.id = ? AND s.nom = ?
        `, [req.params.id, req.params.nom]);

        if (rows.length > 0) {
            res.send(rows);
        } else {
            res.send("No s'ha trobat la skin per a aquest usuari");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


/**
 * @swagger
 * /skins/:
 *   post:
 *     tags: [Skins]
 *     summary: Crear una nova skin
 *     description: |
 *       Afegeix una nova skin a la base de dades.
 *       **Nota**: Cal especificar l'email a la capçalera `Content-Type`.
 *       Si l'usuari no és administrador, no podrà realitzar aquesta acció.
 *
 *       **Exemple de sol·licitud**:
 *       ```json
 *       {
 *         "email": "exemple@gmail.com",
 *         "nom": "Skin Nova",
 *         "categoria": 1,
 *         "imatge": "imatge.png",
 *         "personatge": 1,
 *         "atac": 1
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
 *               - categoria
 *               - imatge
 *               - personatge
 *               - atac
 *             properties:
 *               nom:
 *                 type: string
 *                 description: Nom de la skin.
 *                 example: "Skin Nova"
 *               categoria:
 *                 type: integer
 *                 description: Categoria de la skin.
 *                 example: 1
 *               imatge:
 *                 type: string
 *                 description: URL de la imatge de la skin.
 *                 example: "imatge.png"
 *               personatge:
 *                 type: integer
 *                 description: ID del personatge associat.
 *                 example: 1
 *               atac:
 *                 type: integer
 *                 description: ID de l'atac associat.
 *                 example: 1
 *     responses:
 *       201:
 *         description: Skin afegida correctament.
 *       500:
 *         description: Error en inserir la skin.
 */
exports.crearSkin = async (req, res) => {
    try {
        const { nom, categoria, imatge, personatge, atac } = req.body;

        const connection = await connectDB();                
        await connection.execute(
            `INSERT INTO SKINS (nom, categoria, imatge, personatge, atac)
             VALUES (?, ?, ?, ?, ?)`,
            [nom, categoria, imatge, personatge, atac]        
        );

        res.status(201).send('Skin afegida correctament');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en inserir la skin');
    }
};


/**
 * @swagger
 * /skins/{id}:
 *   delete:
 *     tags: [Skins]
 *     summary: Eliminar una skin per ID i eliminar-la de la biblioteca dels usuaris
 *     description: Aquesta API elimina una skin de la base de dades per ID.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID de la skin a eliminar.
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Skin eliminada correctament.
 *       404:
 *         description: Skin no trobada.
 *       500:
 *         description: Error en eliminar la skin.
 */
exports.borrarSkinId = async (req, res) => {
    try {
        const connection = await connectDB();
        const skinId = req.params.id;

        // 🗑️ Eliminar la skin de la taula SKINS
        const [deleteResult] = await connection.execute(
            'DELETE FROM SKINS WHERE id = ?',
            [skinId]
        );

        if (deleteResult.affectedRows === 0) {
            return res.status(404).send('Skin no trobada');
        }

        // 🧹 Actualitzar els valors de skin_ids a BIBLIOTECA
        await connection.execute(`
            UPDATE BIBLIOTECA
            SET skin_ids = TRIM(BOTH ',' FROM REPLACE(
                REPLACE(
                    REPLACE(CONCAT(',', skin_ids, ','), CONCAT(',', ?, ','), ','), 
                    CONCAT(',', ?), ''
                ),
                CONCAT(?, ','), ''
            ))
            WHERE skin_ids LIKE CONCAT('%', ?, '%')
        `, [skinId, skinId, skinId, skinId]);

        res.send('Skin eliminada correctament i BIBLIOTECA actualitzada');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en eliminar la skin');
    }
};



/**
 * @swagger
 * /gacha:
 *   post:
 *     tags: [Skins]
 *     summary: Realitzar una tirada de gacha per un usuari
 *     description: Aquest mètode permet a un usuari realitzar una tirada aleatòria de gacha per obtenir una skin, però només si té prou monedes.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: Correu electrònic de l'usuari per identificar-lo.
 *                 example: "usuari@exemple.com"
 *     responses:
 *       200:
 *         description: Tirada de gacha realitzada amb èxit.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: Missatge d'èxit.
 *                 skin:
 *                   type: object
 *                   description: La skin obtinguda de la tirada.
 *                   properties:
 *                     id:
 *                       type: integer
 *                       description: ID de la skin.
 *                     nom:
 *                       type: string
 *                       description: Nom de la skin.
 *                 remainingCoins:
 *                   type: integer
 *                   description: Nombre de monedes restants de l'usuari després de la tirada.
 *       400:
 *         description: Error per falta d'email, saldo insuficient o usuari no trobat.
 *       500:
 *         description: Error en realitzar la tirada de gacha.
 */
exports.gachaTirada = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const userId = userRecord[0].id;
        const currentBalance = userRecord[0].punts_emmagatzemats;

        if (currentBalance < 100) {
            return res.status(400).send('No tens prou monedes per fer la tirada.');
        }

        // Obtenir les skins disponibles
        const [availableSkins] = await connection.execute(`
            SELECT *
            FROM SKINS s
            WHERE s.raça = 1
              AND (
                  NOT EXISTS (
                      SELECT 1
                      FROM ENEMICS e
                      WHERE e.personatge_id = s.personatge
                  )
                  OR s.nom LIKE '%bo%'
              )
        `);

        if (availableSkins.length === 0) {
            return res.status(400).send('No hi ha skins disponibles.');
        }

        // Classificar per categoria
        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        availableSkins.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        // Probabilitats acumulatives
        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const rand = Math.random();
        let chosenStars = 1;
        for (const prob of probabilities) {
            if (rand <= prob.threshold) {
                chosenStars = prob.stars;
                break;
            }
        }

        // Si no hi ha skins en aquesta categoria, buscar cap avall
        while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
            chosenStars--;
        }

        const selectedGroup = starGroups[chosenStars];

        if (selectedGroup.length === 0) {
            return res.status(400).send('No hi ha skins disponibles en aquesta categoria.');
        }

        // Consultar quines té ja
        const [userSkins] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?',
            [userId]
        );

        let userSkinIds = [];
        if (userSkins.length > 0) {
            userSkinIds = userSkins
                .map(row => row.skin_ids)
                .filter(Boolean)
                .flatMap(ids => ids.split(','));
        }

        // Separar noves i repetides
        const newSkins = [];
        const ownedSkins = [];

        selectedGroup.forEach(skin => {
            if (userSkinIds.includes(String(skin.id))) {
                ownedSkins.push(skin);
            } else {
                newSkins.push(skin);
            }
        });

        // Pesos: 55% noves, 45% repetides
        let finalPool = [];

        if (newSkins.length > 0 && ownedSkins.length > 0) {
            const newWeight = 0.55;
            const ownedWeight = 0.45;

            const totalSamples = 100;
            finalPool = [
                ...Array(Math.floor(newWeight * totalSamples)).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                ...Array(Math.floor(ownedWeight * totalSamples)).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
            ];
        } else if (newSkins.length > 0) {
            finalPool = newSkins;
        } else {
            finalPool = ownedSkins;
        }

        const randomSkin = finalPool[Math.floor(Math.random() * finalPool.length)];

        // 🔥 Comprovar habilitat llegendària
        const [habilitatResult] = await connection.execute(
            'SELECT * FROM HABILITAT_LLEGENDARIA WHERE skin_personatge = ?',
            [randomSkin.id]
        );

        if (habilitatResult.length > 0) {
            randomSkin.habilitat_llegendaria = habilitatResult[0];

            const [personatgeResult] = await connection.execute(
                'SELECT nom FROM PERSONATGES WHERE id = ?',
                [randomSkin.personatge]
            );

            if (personatgeResult.length > 0) {
                const carpeta = personatgeResult[0].nom
                    .toLowerCase()
                    .replace(/[^\w]/g, '_')
                    .replace(/_+/g, '_')
                    .replace(/^_+|_+$/g, '');

                randomSkin.video_especial = `assets/special_attack/${carpeta}/${carpeta}_gacha.mp4`;
            }
        }

        // Si ja la té, no restem monedes
        if (userSkinIds.includes(String(randomSkin.id))) {
            return res.status(200).send({
                message: "Ja tens aquesta skin.",
                skin: randomSkin,
                remainingCoins: currentBalance,
            });
        }

        // Registrar la nova skin i restar monedes
        const newBalance = currentBalance - 100;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, userId]
        );

        userSkinIds.push(String(randomSkin.id));
        const updatedSkinIds = userSkinIds.join(',');

        const [existingRecord] = await connection.execute(
            'SELECT * FROM BIBLIOTECA WHERE user_id = ? AND personatge_id = ?',
            [userId, randomSkin.personatge]
        );

        if (existingRecord.length === 0) {
            await connection.execute(
                `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                 VALUES (?, ?, NOW(), ?)`,
                [userId, randomSkin.personatge, updatedSkinIds]
            );
        } else {
            await connection.execute(
                `UPDATE BIBLIOTECA
                 SET skin_ids = ?
                 WHERE user_id = ? AND personatge_id = ?`,
                [updatedSkinIds, userId, randomSkin.personatge]
            );
        }

        res.status(200).send({
            message: '¡Tirada gacha realitzada amb èxit!',
            skin: randomSkin,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada de gacha');
    }
};


exports.gachaSimulacio = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        // Buscar l'usuari per email
        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const userId = userRecord[0].id;
        const currentBalance = userRecord[0].punts_emmagatzemats;

        if (currentBalance < 100) {
            return res.status(400).send('No tens prou monedes per fer la tirada.');
        }

        // 🔄 Simular que sempre toca la skin amb ID 237
        const [simulatedSkinResult] = await connection.execute(
            'SELECT * FROM SKINS WHERE id = ?',
            [233]
        );

        if (simulatedSkinResult.length === 0) {
            return res.status(400).send('No s\'ha trobat la skin simulada.');
        }

        const randomSkin = simulatedSkinResult[0];

        // 🔥 Comprovar si té habilitat llegendària
        const [habilitatResult] = await connection.execute(
            'SELECT * FROM HABILITAT_LLEGENDARIA WHERE skin_personatge = ?',
            [randomSkin.id]
        );

        if (habilitatResult.length > 0) {
            randomSkin.habilitat_llegendaria = habilitatResult[0];

            // 🧠 Agafar el nom del personatge per crear el path del vídeo
            const [personatgeResult] = await connection.execute(
                'SELECT nom FROM PERSONATGES WHERE id = ?',
                [randomSkin.personatge]
            );

            if (personatgeResult.length > 0) {
                const personatgeNom = personatgeResult[0].nom;

                const carpeta = personatgeNom
                    .toLowerCase()
                    .replace(/[^\w]/g, '_')   // substitueix espais i símbols
                    .replace(/_+/g, '_')       // agrupa múltiples guions baixos
                    .replace(/^_+|_+$/g, '');  // elimina guions al principi/final

                randomSkin.video_especial = `assets/special_attack/${carpeta}/${carpeta}_gacha.mp4`;
            }
        }

        // Comprovar si l'usuari ja té la skin
        const [userSkins] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ? AND personatge_id = ?',
            [userId, randomSkin.personatge]
        );

        let userSkinIds = userSkins.length > 0 && userSkins[0].skin_ids
            ? userSkins[0].skin_ids.split(',')
            : [];

        if (userSkinIds.includes(String(randomSkin.id))) {
            // Ja té aquesta skin: NO restem monedes
            return res.status(200).send({
                message: "Ja tens aquesta skin.",
                skin: randomSkin,
                remainingCoins: currentBalance,
            });
        }

        // Afegir la nova skin i restar les monedes
        const newBalance = currentBalance - 100;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, userId]
        );

        userSkinIds.push(String(randomSkin.id));
        const updatedSkinIds = userSkinIds.join(',');

        if (userSkins.length === 0) {
            await connection.execute(
                `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                 VALUES (?, ?, NOW(), ?)`,
                [userId, randomSkin.personatge, updatedSkinIds]
            );
        } else {
            await connection.execute(
                `UPDATE BIBLIOTECA
                 SET skin_ids = ?
                 WHERE user_id = ? AND personatge_id = ?`,
                [updatedSkinIds, userId, randomSkin.personatge]
            );
        }

        res.status(200).send({
            message: '¡Tirada gacha realitzada amb èxit!',
            skin: randomSkin,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada de gacha');
    }
};




exports.seleccionarSkinAleatoria = async (req, res) => {
    try {
        const connection = await connectDB(); // connexió MySQL

        // Obtenir l'hora actual
        const horaActual = Number(new Intl.DateTimeFormat('es-ES', {
    hour: 'numeric',
    hour12: false,
    timeZone: 'Europe/Madrid'
        }).format(new Date()));


        // Definir dia (7:00 a 16:59) i vespre (17:00 a 6:59)
        const esDia = horaActual >= 7 && horaActual < 17;
        const raçaSeleccionada = esDia ? 0 : 2;

        // Obtenir les skins amb la raça corresponent
        const [resultSkins] = await connection.execute(`
            SELECT s.id,
                   s.nom,
                   s.categoria,
                   s.imatge,
                   e.punts_donats,
                   s.personatge,
                   p.nom AS nom_personatge,
                   p.vida_base AS vida_personatge
            FROM SKINS s
            INNER JOIN PERSONATGES p ON s.personatge = p.id
            INNER JOIN ENEMICS e ON e.personatge_id = p.id
            WHERE s.nom NOT LIKE '%bo%' AND s.raça = ?
        `, [raçaSeleccionada]);

        if (resultSkins.length === 0) {
            return res.status(404).send('No hi ha skins disponibles per als enemics');
        }

        // Seleccionar una skin aleatòria
        const skinAleatoria = resultSkins[Math.floor(Math.random() * resultSkins.length)];

        // Obtenir el mal base del personatge
        const [resultMalBase] = await connection.execute(`
            SELECT mal_base
            FROM PERSONATGES
            WHERE id = ?
        `, [skinAleatoria.personatge]);

        if (resultMalBase.length === 0) {
            return res.status(404).send('Personatge no trobat');
        }

        const malBase = resultMalBase[0].mal_base;
        const malTotal = malBase; // Aquí pots afegir més càlculs si cal

        // Retornar la resposta
        res.status(200).json({
            skin: {
                id: skinAleatoria.id,
                nom: skinAleatoria.nom,
                categoria: skinAleatoria.categoria,
                imatge: skinAleatoria.imatge,
                punts_donats: skinAleatoria.punts_donats,
                mal_total: malTotal,
                personatge_nom: skinAleatoria.nom_personatge,
                vida: skinAleatoria.vida_personatge
            }
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en el servidor');
    }
};


/**
 * @swagger
 * /user/{id}/personatges:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir tots els personatges d'un usuari amb totes les seves skins i les seves dades completes
 *     description: Aquesta API retorna tots els personatges que té un usuari, juntament amb totes les skins i les seves dades completes, incloent el mal total.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID de l'usuari per obtenir els seus personatges i skins.
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Llista de personatges amb totes les seves dades i les skins associades, incloent el mal total.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   personatge:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       nom:
 *                         type: string
 *                       vida_base:
 *                         type: integer
 *                       mal_base:
 *                         type: integer
 *                       imatge:
 *                         type: string
 *                   skins:
 *                     type: array
 *                     items:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: integer
 *                         nom:
 *                           type: string
 *                         descripcio:
 *                           type: string
 *                         imatge:
 *                           type: string
 *                         categoria:
 *                           type: string
 *                         mal_total:
 *                           type: integer
 *       404:
 *         description: No s'han trobat personatges per a aquest usuari.
 *       500:
 *         description: Error en la consulta.
 */
    exports.getPersonatgesAmbSkinsPerUsuari = async (req, res) => {
    try {
        const connection = await connectDB();
        const userId = req.params.id;

        // Obtenir els personatges de l'usuari
        const [personatgesResult] = await connection.execute(`
            SELECT DISTINCT p.id AS personatge_id,
                            p.nom AS personatge_nom,
                            p.vida_base,
                            p.mal_base
            FROM PERSONATGES p
            JOIN BIBLIOTECA b ON p.id = b.personatge_id
            JOIN SKINS s ON s.personatge = p.id
            WHERE b.user_id = ? AND s.raça = 1
            ORDER BY p.nom
        `, [userId]);

        if (personatgesResult.length === 0) {
        return res.status(404).send('No s\'han trobat personatges per a aquest usuari');
        }

        // Obtenir les skins amb l’arma equipada per l’usuari
        const [skinsResult] = await connection.execute(`
            SELECT s.id AS skin_id,
                s.nom AS skin_nom,
                s.categoria,
                s.imatge,
                s.raça,
                a.mal AS mal_arma,
                a.nom AS atac_nom,
                ar.buff_atac AS atac,
                ar.id AS arma_id,
                ar.nom AS arma_nom,
                b.personatge_id,
                usa.vida_actual
            FROM SKINS s
            JOIN BIBLIOTECA b ON FIND_IN_SET(s.id, b.skin_ids) > 0
            LEFT JOIN USUARI_SKIN_ARMES usa ON usa.skin = s.id AND usa.usuari = ?
            LEFT JOIN ARMES ar ON usa.arma = ar.id
            LEFT JOIN ATACS a ON s.atac = a.id
            WHERE b.user_id = ? AND s.raça = 1
        `, [userId, userId]);

        // Agrupar les skins per personatge
        const skinsPerPersonatge = {};
        skinsResult.forEach(skin => {
        if (!skinsPerPersonatge[skin.personatge_id]) {
            skinsPerPersonatge[skin.personatge_id] = [];
        }
        skinsPerPersonatge[skin.personatge_id].push(skin);
        });

        // Construir la resposta final
        const personatgesAmbSkins = personatgesResult.map(personatge => {
        const skins = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
            id: skin.skin_id,
            nom: skin.skin_nom,
            imatge: skin.imatge,
            raça: skin.raça,
            categoria: skin.categoria,
            mal_total: personatge.mal_base + (skin.mal_arma || 0) + (skin.atac || 0),
            vida: skin.vida_actual !== null ? skin.vida_actual : personatge.vida_base,
            vida_maxima: personatge.vida_base,
            atac_nom: skin.atac_nom,
            arma: {
            id: skin.arma_id || null,
            nom: skin.arma_nom || null,
            buff_atac: skin.atac || 0
  }
}));


        return {
            personatge: {
            id: personatge.personatge_id,
            nom: personatge.personatge_nom,
            vida_base: personatge.vida_base,
            mal_base: personatge.mal_base,
            },
            skins: skins
        };
        });

        res.status(200).json(personatgesAmbSkins);

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
    };





/**
 * @swagger
 * /enemics/personatges:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir tots els personatges enemics amb totes les seves skins i les seves dades completes
 *     description: Aquesta API retorna tots els personatges enemics, juntament amb totes les skins i les seves dades completes, incloent el mal total.
 *     responses:
 *       200:
 *         description: Llista de personatges enemics amb totes les seves dades i les skins associades, incloent el mal total.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   personatge:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                       nom:
 *                         type: string
 *                       vida_base:
 *                         type: integer
 *                       mal_base:
 *                         type: integer
 *                       imatge:
 *                         type: string
 *                   skins:
 *                     type: array
 *                     items:
 *                       type: object
 *                       properties:
 *                         id:
 *                           type: integer
 *                         nom:
 *                           type: string
 *                         descripcio:
 *                           type: string
 *                         imatge:
 *                           type: string
 *                         categoria:
 *                           type: string
 *                         mal_total:
 *                           type: integer
 *       404:
 *         description: No s'han trobat personatges enemics.
 *       500:
 *         description: Error en la consulta.
 */
exports.getPersonatgesEnemicsAmbSkins = async (req, res) => {
    try {
        const connection = await connectDB();

        // 1. Obtenir tots els personatges enemics
        const [personatgesResult] = await connection.execute(`
            SELECT DISTINCT p.id AS personatge_id, p.nom AS personatge_nom,
                            p.vida_base, p.mal_base
            FROM PERSONATGES p
            JOIN ENEMICS e ON p.id = e.personatge_id
        `);

        if (personatgesResult.length === 0) {
            return res.status(404).send('No s\'han trobat personatges enemics');
        }

        const personatgeIds = personatgesResult.map(p => p.personatge_id);

        if (personatgeIds.length === 0) {
            // Si no hi ha ids, respondre ja amb buit
            return res.status(200).json([]);
        }

        // 2. Obtenir totes les skins dels personatges enemics, excloent les que tenen "bo" al nom
        // Per evitar SQL injection, utilitzem placeholders dinàmics amb la quantitat d'ids
        const placeholders = personatgeIds.map(() => '?').join(',');

        const [skinsResult] = await connection.execute(
            `
            SELECT s.id AS skin_id, s.nom AS skin_nom, s.categoria, s.imatge,
                   s.personatge AS personatge_id
            FROM SKINS s
            WHERE s.personatge IN (${placeholders})
              AND s.nom NOT LIKE '%Bo%'
            `, 
            personatgeIds
        );

        // 3. Agrupar les skins per personatge
        const skinsPerPersonatge = {};
        skinsResult.forEach(skin => {
            if (!skinsPerPersonatge[skin.personatge_id]) {
                skinsPerPersonatge[skin.personatge_id] = [];
            }
            skinsPerPersonatge[skin.personatge_id].push(skin);
        });

        // 4. Construir la resposta final
        const personatgesAmbSkins = personatgesResult.map(personatge => {
            const skins = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
                id: skin.skin_id,
                nom: skin.skin_nom,
                imatge: skin.imatge,
                categoria: skin.categoria,
                mal_total: personatge.mal_base // no tens mal_arma ni atac per aquí, els deixo fora
            }));

            return {
                personatge: {
                    id: personatge.personatge_id,
                    nom: personatge.personatge_nom,
                    vida_base: personatge.vida_base,
                    mal_base: personatge.mal_base,
                    // imatge no està seleccionada, si la vols caldria afegir-la a la consulta inicial
                },
                skins: skins
            };
        });

        res.status(200).json(personatgesAmbSkins);

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};


exports.gachaTiradaQuincy = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionado.');
        }

        const connection = await connectDB();

        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No se encuentra un usuario con ese correo electrónico.');
        }

        const user = userRecord[0];

        if (user.punts_emmagatzemats < 100) {
            return res.status(400).send('No tienes suficientes monedas para hacer el tiro.');
        }

        // Obtenir totes les skins disponibles (raça=0), excloent enemics
        const [availableSkins] = await connection.execute(`
            SELECT *
            FROM SKINS s
            WHERE s.raça = 0
              AND NOT EXISTS (
                  SELECT 1 FROM ENEMICS e WHERE e.personatge_id = s.personatge
              )
        `);

        if (availableSkins.length === 0) {
            return res.status(400).send('No hi ha skins disponibles.');
        }

        // Classificar per categoria
        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        availableSkins.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        // Probabilitats acumulatives
        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const rand = Math.random();
        let chosenStars = 1;
        for (const prob of probabilities) {
            if (rand <= prob.threshold) {
                chosenStars = prob.stars;
                break;
            }
        }

        while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
            chosenStars--;
        }

        const selectedGroup = starGroups[chosenStars];

        // Obtenir skins del jugador (totes)
        const [allUserSkins] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?',
            [user.id]
        );

        let userSkinIds = allUserSkins
            .map(row => row.skin_ids)
            .filter(Boolean)
            .flatMap(ids => ids.split(','));

        // Separar en noves i repetides
        const newSkins = [];
        const ownedSkins = [];

        selectedGroup.forEach(skin => {
            if (userSkinIds.includes(String(skin.id))) {
                ownedSkins.push(skin);
            } else {
                newSkins.push(skin);
            }
        });

        // Crear el pool segons els pesos (55% noves, 45% repetides)
        let finalPool = [];

        if (newSkins.length > 0 && ownedSkins.length > 0) {
            const newWeight = 0.55;
            const ownedWeight = 0.45;
            const totalSamples = 100;

            finalPool = [
                ...Array(Math.floor(newWeight * totalSamples)).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                ...Array(Math.floor(ownedWeight * totalSamples)).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
            ];
        } else if (newSkins.length > 0) {
            finalPool = newSkins;
        } else {
            finalPool = ownedSkins;
        }

        const randomSkin = finalPool[Math.floor(Math.random() * finalPool.length)];

        // Si ja té la skin → no descomptar i tornar resposta
        if (userSkinIds.includes(String(randomSkin.id))) {
            return res.status(200).send({
                message: "Ja tens aquesta skin.",
                skin: randomSkin,
                remainingCoins: user.punts_emmagatzemats,
            });
        }

        // Descomptar 100 monedes
        const newBalance = user.punts_emmagatzemats - 100;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, user.id]
        );

        // Registrar nova skin
        userSkinIds.push(String(randomSkin.id));
        const updatedSkinIds = userSkinIds.join(',');

        const [existingRecord] = await connection.execute(
            'SELECT * FROM BIBLIOTECA WHERE user_id = ? AND personatge_id = ?',
            [user.id, randomSkin.personatge]
        );

        if (existingRecord.length === 0) {
            await connection.execute(
                `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                 VALUES (?, ?, NOW(), ?)`,
                [user.id, randomSkin.personatge, updatedSkinIds]
            );
        } else {
            await connection.execute(
                `UPDATE BIBLIOTECA
                 SET skin_ids = ?
                 WHERE user_id = ? AND personatge_id = ?`,
                [updatedSkinIds, user.id, randomSkin.personatge]
            );
        }

        res.status(200).send({
            message: '¡Tirada gacha realitzada amb èxit!',
            skin: randomSkin,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada de gacha');
    }
};


exports.getPersonatgesAmbSkinsPerUsuariQuincy = async (req, res) => {
  try {
    const pool = await connectDB();
    const userId = req.params.id;

    // Obtenir els personatges Quincy que té l'usuari a la biblioteca, només raça 0
    const [personatges] = await pool.execute(`
      SELECT DISTINCT p.id AS personatge_id,
                      p.nom AS personatge_nom,
                      p.vida_base,
                      p.mal_base
      FROM PERSONATGES p
      JOIN BIBLIOTECA b ON p.id = b.personatge_id
      JOIN SKINS s ON s.personatge = p.id
      WHERE b.user_id = ? AND s.raça = 0
      ORDER BY p.nom
    `, [userId]);

    if (personatges.length === 0) {
      return res.status(404).send("No s'han trobat personatges per a aquest usuari");
    }

    // Obtenir totes les skins de raça 0 de l'usuari, amb dades de les armes i atac
    const [skins] = await pool.execute(`
      SELECT s.id         AS skin_id,
             s.nom        AS skin_nom,
             s.categoria,
             s.imatge,
             a.mal        AS mal_arma,
             a.nom        AS atac_nom,
             ar.buff_atac AS atac,
             b.personatge_id
      FROM SKINS s
      JOIN BIBLIOTECA b ON FIND_IN_SET(s.id, b.skin_ids) > 0
      LEFT JOIN SKINS_ARMES sa ON s.id = sa.skin
      LEFT JOIN ARMES ar ON sa.arma = ar.id
      LEFT JOIN ATACS a ON s.atac = a.id
      WHERE b.user_id = ? AND s.raça = 0
    `, [userId]);

    // Agrupar les skins per personatge
    const skinsPerPersonatge = {};
    skins.forEach(skin => {
      if (!skinsPerPersonatge[skin.personatge_id]) {
        skinsPerPersonatge[skin.personatge_id] = [];
      }
      skinsPerPersonatge[skin.personatge_id].push(skin);
    });

    // Construir la resposta
    const personatgesAmbSkins = personatges.map(personatge => {
      const skinsArr = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
        id: skin.skin_id,
        nom: skin.skin_nom,
        imatge: skin.imatge,
        categoria: skin.categoria,
        mal_total: personatge.mal_base + (skin.mal_arma || 0) + (skin.atac || 0),
        vida: personatge.vida_base,
        atac_nom: skin.atac_nom
      }));

      return {
        personatge: {
          id: personatge.personatge_id,
          nom: personatge.personatge_nom,
          vida_base: personatge.vida_base,
          mal_base: personatge.mal_base,
        },
        skins: skinsArr
      };
    });

    res.status(200).json(personatgesAmbSkins);

  } catch (err) {
    console.error(err);
    res.status(500).send('Error en la consulta');
  }
};


exports.gachaTiradaEnemics = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        // Obtenir usuari per email
        const [userRows] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRows.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const user = userRows[0];

        if (user.punts_emmagatzemats < 100) {
            return res.status(400).send('No tens suficients monedes per fer la tirada.');
        }

        // Obtenir totes les skins enemigues disponibles (raça 2)
        const [skinsRows] = await connection.execute(
            'SELECT * FROM SKINS WHERE raça = 2'
        );

        if (skinsRows.length === 0) {
            return res.status(400).send('No hi ha skins enemigues disponibles.');
        }

        // Agrupar per categoria
        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        skinsRows.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        // Probabilitats acumulatives
        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const rand = Math.random();
        let chosenStars = 1;

        for (const prob of probabilities) {
            if (rand <= prob.threshold) {
                chosenStars = prob.stars;
                break;
            }
        }

        while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
            chosenStars--;
        }

        const selectedGroup = starGroups[chosenStars];

        // Obtenir totes les skins del jugador
        const [allUserSkins] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?',
            [user.id]
        );

        let userSkinIds = allUserSkins
            .map(row => row.skin_ids)
            .filter(Boolean)
            .flatMap(ids => ids.split(','));

        // Separar en noves i repetides
        const newSkins = [];
        const ownedSkins = [];

        selectedGroup.forEach(skin => {
            if (userSkinIds.includes(String(skin.id))) {
                ownedSkins.push(skin);
            } else {
                newSkins.push(skin);
            }
        });

        // Crear el pool segons els pesos
        let finalPool = [];

        if (newSkins.length > 0 && ownedSkins.length > 0) {
            const newWeight = 0.55;
            const ownedWeight = 0.45;
            const totalSamples = 100;

            finalPool = [
                ...Array(Math.floor(newWeight * totalSamples)).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                ...Array(Math.floor(ownedWeight * totalSamples)).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
            ];
        } else if (newSkins.length > 0) {
            finalPool = newSkins;
        } else {
            finalPool = ownedSkins;
        }

        const randomSkin = finalPool[Math.floor(Math.random() * finalPool.length)];

        // Comprovar si ja té la skin
        const [userSkinRows] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ? AND personatge_id = ?',
            [user.id, randomSkin.personatge]
        );

        let existingSkinIds = [];
        if (userSkinRows.length > 0 && userSkinRows[0].skin_ids) {
            existingSkinIds = userSkinRows[0].skin_ids.split(',');
        }

        const alreadyOwned = existingSkinIds.includes(String(randomSkin.id));

        if (alreadyOwned) {
            // Retornar les monedes
            return res.status(200).send({
                message: 'Ja tens aquesta skin.',
                skin: randomSkin,
                remainingCoins: user.punts_emmagatzemats,
            });
        }

        // Descomptar monedes
        const newBalance = user.punts_emmagatzemats - 100;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, user.id]
        );

        // Afegir skin
        existingSkinIds.push(String(randomSkin.id));
        const updatedSkinIds = existingSkinIds.join(',');

        if (userSkinRows.length === 0) {
            await connection.execute(
                'INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids) VALUES (?, ?, ?, ?)',
                [user.id, randomSkin.personatge, new Date(), updatedSkinIds]
            );
        } else {
            await connection.execute(
                'UPDATE BIBLIOTECA SET skin_ids = ? WHERE user_id = ? AND personatge_id = ?',
                [updatedSkinIds, user.id, randomSkin.personatge]
            );
        }

        res.status(200).send({
            message: '¡Tirada gacha realitzada amb èxit!',
            skin: randomSkin,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada de gacha');
    }
};



exports.getPersonatgesAmbSkinsPerUsuariEnemics = async (req, res) => {
  try {
    const pool = await connectDB();
    const userId = req.params.id;

    // Obtenir els personatges enemics que té l'usuari, excloent skins amb "bo" al nom
    const [personatges] = await pool.execute(`
      SELECT DISTINCT p.id AS personatge_id,
                      p.nom AS personatge_nom,
                      p.vida_base,
                      p.mal_base
      FROM PERSONATGES p
      JOIN BIBLIOTECA b ON p.id = b.personatge_id
      JOIN SKINS s ON s.personatge = p.id
      JOIN ENEMICS e ON e.personatge_id = p.id
      WHERE b.user_id = ?
        AND s.raça = 2
        AND s.nom NOT LIKE '%bo%'
      ORDER BY p.nom
    `, [userId]);

    if (personatges.length === 0) {
      return res.status(404).send("No s'han trobat personatges per a aquest usuari");
    }

    // Obtenir totes les skins de raça 2 (enemics) de l'usuari, amb dades d'armes i atac
    const [skins] = await pool.execute(`
      SELECT s.id         AS skin_id,
             s.nom        AS skin_nom,
             s.categoria,
             s.imatge,
             s.raça,
             a.mal        AS mal_arma,
             a.nom        AS atac_nom,
             ar.buff_atac AS atac,
             b.personatge_id
      FROM SKINS s
      JOIN BIBLIOTECA b ON FIND_IN_SET(s.id, b.skin_ids) > 0
      LEFT JOIN SKINS_ARMES sa ON s.id = sa.skin
      LEFT JOIN ARMES ar ON sa.arma = ar.id
      LEFT JOIN ATACS a ON s.atac = a.id
      WHERE b.user_id = ? AND s.raça = 2
    `, [userId]);

    // Agrupar les skins per personatge
    const skinsPerPersonatge = {};
    skins.forEach(skin => {
      if (!skinsPerPersonatge[skin.personatge_id]) {
        skinsPerPersonatge[skin.personatge_id] = [];
      }
      skinsPerPersonatge[skin.personatge_id].push(skin);
    });

    // Construir la resposta final
    const personatgesAmbSkins = personatges.map(personatge => {
      const skinsArr = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
        id: skin.skin_id,
        nom: skin.skin_nom,
        imatge: skin.imatge,
        categoria: skin.categoria,
        mal_total: personatge.mal_base + (skin.mal_arma || 0) + (skin.atac || 0),
        vida: personatge.vida_base,
        atac_nom: skin.atac_nom,
        raça: skin.raça
      }));

      return {
        personatge: {
          id: personatge.personatge_id,
          nom: personatge.personatge_nom,
          vida_base: personatge.vida_base,
          mal_base: personatge.mal_base,
        },
        skins: skinsArr
      };
    });

    res.status(200).json(personatgesAmbSkins);

  } catch (err) {
    console.error(err);
    res.status(500).send('Error en la consulta');
  }
};


//Endpoint per poder realitzar una tirada gacha de 5 Shinigami
exports.gachaMultiSH = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const userId = userRecord[0].id;
        const currentBalance = userRecord[0].punts_emmagatzemats;

        if (currentBalance < 500) {
            return res.status(400).send('No tens prou monedes per fer la tirada múltiple.');
        }

        const newBalance = currentBalance - 500;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, userId]
        );

        const [availableSkins] = await connection.execute(`
            SELECT *
            FROM SKINS s
            WHERE s.raça = 1
              AND (
                  NOT EXISTS (
                      SELECT 1
                      FROM ENEMICS e
                      WHERE e.personatge_id = s.personatge
                  )
                  OR s.nom LIKE '%bo%'
              )
        `);

        if (availableSkins.length === 0) {
            return res.status(400).send('No hi ha skins disponibles.');
        }

        const [allUserSkins] = await connection.execute(
            'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ?',
            [userId]
        );

        const ownedSkinIds = new Set();
        allUserSkins.forEach(row => {
            if (row.skin_ids) {
                row.skin_ids.split(',').forEach(id => ownedSkinIds.add(id));
            }
        });

        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        availableSkins.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const tirades = [];
        let repetides = 0;
        let noves = 0;

        for (let i = 0; i < 5; i++) {
            const rand = Math.random();
            let chosenStars = 1;
            for (const prob of probabilities) {
                if (rand <= prob.threshold) {
                    chosenStars = prob.stars;
                    break;
                }
            }

            while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
                chosenStars--;
            }

            const group = starGroups[chosenStars];

            const newSkins = [];
            const ownedSkins = [];

            group.forEach(skin => {
                if (ownedSkinIds.has(String(skin.id))) {
                    ownedSkins.push(skin);
                } else {
                    newSkins.push(skin);
                }
            });

            let finalPool = [];
            const newWeight = 0.55;
            const ownedWeight = 0.45;

            if (newSkins.length > 0 && ownedSkins.length > 0) {
                const totalSamples = 100;
                finalPool = [
                    ...Array(Math.floor(newWeight * totalSamples)).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                    ...Array(Math.floor(ownedWeight * totalSamples)).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
                ];
            } else if (newSkins.length > 0) {
                finalPool = newSkins;
            } else {
                finalPool = ownedSkins;
            }

            const randomSkin = finalPool[Math.floor(Math.random() * finalPool.length)];

            const [userSkins] = await connection.execute(
                'SELECT skin_ids FROM BIBLIOTECA WHERE user_id = ? AND personatge_id = ?',
                [userId, randomSkin.personatge]
            );

            let userSkinIds = userSkins.length > 0 && userSkins[0].skin_ids
                ? userSkins[0].skin_ids.split(',')
                : [];

            const jaTenia = userSkinIds.includes(String(randomSkin.id));

            if (!jaTenia) {
                noves++;
                userSkinIds.push(String(randomSkin.id));
                const updatedSkinIds = userSkinIds.join(',');

                if (userSkins.length === 0) {
                    await connection.execute(
                        `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                         VALUES (?, ?, NOW(), ?)`,
                        [userId, randomSkin.personatge, updatedSkinIds]
                    );
                } else {
                    await connection.execute(
                        `UPDATE BIBLIOTECA
                         SET skin_ids = ?
                         WHERE user_id = ? AND personatge_id = ?`,
                        [updatedSkinIds, userId, randomSkin.personatge]
                    );
                }

                ownedSkinIds.add(String(randomSkin.id)); // afegim com a adquirida
            } else {
                repetides++;
            }

            tirades.push({
                skin: randomSkin,
                jaTenia
            });
        }

        const availableSkinsNotOwned = availableSkins.filter(skin => !ownedSkinIds.has(String(skin.id)));

        res.status(200).send({
            message: '¡Tirada gacha x5 realitzada amb èxit!',
            skins: tirades,
            repetides,
            noves,
            disponibles: availableSkinsNotOwned,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada múltiple de gacha');
    }
};


// Endpoint per poder realitzar una tirada gacha de 5 Quincys
exports.gachaMultiQU = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const userId = userRecord[0].id;
        const currentBalance = userRecord[0].punts_emmagatzemats;

        if (currentBalance < 500) {
            return res.status(400).send('No tens prou monedes per fer la tirada múltiple.');
        }

        const newBalance = currentBalance - 500;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, userId]
        );

        const [availableSkins] = await connection.execute(`
            SELECT * FROM SKINS WHERE raça = 0
        `);

        if (availableSkins.length === 0) {
            return res.status(400).send('No hi ha skins disponibles.');
        }

        // Obtenir totes les skins que ja té l’usuari
        const [allUserSkins] = await connection.execute(
            'SELECT skin_ids, personatge_id FROM BIBLIOTECA WHERE user_id = ?',
            [userId]
        );

        const ownedSkinIds = new Set();
        const skinsPerPersonatge = {};

        allUserSkins.forEach(row => {
            if (row.skin_ids) {
                const ids = row.skin_ids.split(',');
                ids.forEach(id => ownedSkinIds.add(id));
                skinsPerPersonatge[row.personatge_id] = ids;
            }
        });

        // Agrupar skins per estrelles
        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        availableSkins.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const tirades = [];
        let repetides = 0;
        let noves = 0;

        for (let i = 0; i < 5; i++) {
            // Determinar categoria per probabilitat
            let rand = Math.random();
            let chosenStars = 1;
            for (const prob of probabilities) {
                if (rand <= prob.threshold) {
                    chosenStars = prob.stars;
                    break;
                }
            }

            // Si no hi ha de la categoria, baixa una estrella
            while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
                chosenStars--;
            }

            const group = starGroups[chosenStars];

            // Separar noves i repetides dins la categoria
            const newSkins = [];
            const ownedSkins = [];

            group.forEach(skin => {
                if (ownedSkinIds.has(String(skin.id))) {
                    ownedSkins.push(skin);
                } else {
                    newSkins.push(skin);
                }
            });

            // Crear pool amb pesos 55% noves, 45% repetides
            let pool = [];
            if (newSkins.length > 0 && ownedSkins.length > 0) {
                pool = [
                    ...Array(55).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                    ...Array(45).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
                ];
            } else if (newSkins.length > 0) {
                pool = newSkins;
            } else {
                pool = ownedSkins;
            }

            const randomSkin = pool[Math.floor(Math.random() * pool.length)];
            const personatgeId = randomSkin.personatge;
            const skinIdStr = String(randomSkin.id);

            const jaTenia = skinsPerPersonatge[personatgeId]?.includes(skinIdStr) ?? false;

            if (!jaTenia) {
                noves++;
                // Afegir la skin nova
                const updatedIds = skinsPerPersonatge[personatgeId]
                    ? [...skinsPerPersonatge[personatgeId], skinIdStr]
                    : [skinIdStr];

                skinsPerPersonatge[personatgeId] = updatedIds;
                ownedSkinIds.add(skinIdStr);
                const updatedSkinIds = updatedIds.join(',');

                if (!allUserSkins.some(r => r.personatge_id === personatgeId)) {
                    await connection.execute(
                        `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                         VALUES (?, ?, NOW(), ?)`,
                        [userId, personatgeId, updatedSkinIds]
                    );
                } else {
                    await connection.execute(
                        `UPDATE BIBLIOTECA SET skin_ids = ? 
                         WHERE user_id = ? AND personatge_id = ?`,
                        [updatedSkinIds, userId, personatgeId]
                    );
                }
            } else {
                repetides++;
            }

            tirades.push({
                skin: randomSkin,
                jaTenia
            });
        }

        const availableSkinsNotOwned = availableSkins.filter(skin => !ownedSkinIds.has(String(skin.id)));

        res.status(200).send({
            message: '¡Tirada gacha x5 realitzada amb èxit!',
            skins: tirades,
            repetides,
            noves,
            disponibles: availableSkinsNotOwned,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada múltiple de gacha');
    }
};

// Endpoint per poder realitzar una tirada gacha de 5 Hollows
exports.gachaMultiHO = async (req, res) => {
    try {
        const email = req.body.email;

        if (!email) {
            return res.status(400).send('Email no proporcionat.');
        }

        const connection = await connectDB();

        const [userRecord] = await connection.execute(
            'SELECT id, punts_emmagatzemats FROM USUARIS WHERE email = ?',
            [email]
        );

        if (userRecord.length === 0) {
            return res.status(400).send('No es troba cap usuari amb aquest correu electrònic.');
        }

        const userId = userRecord[0].id;
        const currentBalance = userRecord[0].punts_emmagatzemats;

        if (currentBalance < 500) {
            return res.status(400).send('No tens prou monedes per fer la tirada múltiple.');
        }

        const newBalance = currentBalance - 500;
        await connection.execute(
            'UPDATE USUARIS SET punts_emmagatzemats = ? WHERE id = ?',
            [newBalance, userId]
        );

        const [availableSkins] = await connection.execute(`
            SELECT * FROM SKINS WHERE raça = 2
        `);

        if (availableSkins.length === 0) {
            return res.status(400).send('No hi ha skins disponibles.');
        }

        const [allUserSkins] = await connection.execute(
            'SELECT skin_ids, personatge_id FROM BIBLIOTECA WHERE user_id = ?',
            [userId]
        );

        const ownedSkinIds = new Set();
        const skinsPerPersonatge = {};

        allUserSkins.forEach(row => {
            if (row.skin_ids) {
                const ids = row.skin_ids.split(',');
                ids.forEach(id => ownedSkinIds.add(id));
                skinsPerPersonatge[row.personatge_id] = ids;
            }
        });

        const starGroups = { 1: [], 2: [], 3: [], 4: [] };
        availableSkins.forEach(skin => {
            if (starGroups[skin.categoria]) {
                starGroups[skin.categoria].push(skin);
            }
        });

        const probabilities = [
            { stars: 1, threshold: 0.40 },
            { stars: 2, threshold: 0.70 },
            { stars: 3, threshold: 0.90 },
            { stars: 4, threshold: 1.00 }
        ];

        const tirades = [];
        let repetides = 0;
        let noves = 0;

        for (let i = 0; i < 5; i++) {
            let rand = Math.random();
            let chosenStars = 1;
            for (const prob of probabilities) {
                if (rand <= prob.threshold) {
                    chosenStars = prob.stars;
                    break;
                }
            }

            while (starGroups[chosenStars].length === 0 && chosenStars > 1) {
                chosenStars--;
            }

            const group = starGroups[chosenStars];
            const newSkins = [];
            const ownedSkins = [];

            group.forEach(skin => {
                if (ownedSkinIds.has(String(skin.id))) {
                    ownedSkins.push(skin);
                } else {
                    newSkins.push(skin);
                }
            });

            let pool = [];
            if (newSkins.length > 0 && ownedSkins.length > 0) {
                pool = [
                    ...Array(55).fill().map(() => newSkins[Math.floor(Math.random() * newSkins.length)]),
                    ...Array(45).fill().map(() => ownedSkins[Math.floor(Math.random() * ownedSkins.length)])
                ];
            } else if (newSkins.length > 0) {
                pool = newSkins;
            } else {
                pool = ownedSkins;
            }

            const randomSkin = pool[Math.floor(Math.random() * pool.length)];
            const personatgeId = randomSkin.personatge;
            const skinIdStr = String(randomSkin.id);

            const jaTenia = skinsPerPersonatge[personatgeId]?.includes(skinIdStr) ?? false;

            if (!jaTenia) {
                noves++;
                const updatedIds = skinsPerPersonatge[personatgeId]
                    ? [...skinsPerPersonatge[personatgeId], skinIdStr]
                    : [skinIdStr];

                skinsPerPersonatge[personatgeId] = updatedIds;
                ownedSkinIds.add(skinIdStr);
                const updatedSkinIds = updatedIds.join(',');

                if (!allUserSkins.some(r => r.personatge_id === personatgeId)) {
                    await connection.execute(
                        `INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                         VALUES (?, ?, NOW(), ?)`,
                        [userId, personatgeId, updatedSkinIds]
                    );
                } else {
                    await connection.execute(
                        `UPDATE BIBLIOTECA
                         SET skin_ids = ?
                         WHERE user_id = ? AND personatge_id = ?`,
                        [updatedSkinIds, userId, personatgeId]
                    );
                }
            } else {
                repetides++;
            }

            tirades.push({
                skin: randomSkin,
                jaTenia
            });
        }

        const availableSkinsNotOwned = availableSkins.filter(skin => !ownedSkinIds.has(String(skin.id)));

        res.status(200).send({
            message: '¡Tirada gacha x5 realitzada amb èxit!',
            skins: tirades,
            repetides,
            noves,
            disponibles: availableSkinsNotOwned,
            remainingCoins: newBalance,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada múltiple de gacha');
    }
};

// Obtenir skin seleccionada
exports.getSkinSeleccionada = async (req, res) => {
    // Parseamos id a número entero
    const usuari = parseInt(req.params.id, 10);

    if (isNaN(usuari)) {
        return res.status(400).json({ error: 'usuariId ha de ser un número vàlid' });
    }

    try {
        const result = await pool.query(
            `SELECT skin
             FROM USUARI_SKIN_ARMES
             WHERE usuari = $1 AND seleccionat = TRUE`,
            [usuari]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'No hi ha cap skin seleccionada' });
        }

        // Devolver la skin seleccionada
        res.status(200).json({ skinSeleccionada: result.rows[0] });
    } catch (error) {
        console.error('Error obtenint skin seleccionada:', error);
        res.status(500).json({ error: 'Error intern del servidor', details: error.message });
    }
};
