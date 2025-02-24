const { connectDB, sql } = require('../config/dbConfig');

/**
 * @swagger
 * tags:
 *   name: Skins
 *   description: Operacions relacionades amb les skins dels personatges
 */


/**
 * @swagger
 * /skins/{id}:
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
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT s.*
                FROM SKINS s
                         JOIN PERSONATGES p ON s.personatge = p.id
                WHERE p.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat skins per a aquest personatge');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins/user/{id}:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir totes les skins d'un personatge d'un usuari
 *     description: Aquesta API retorna totes les skins d'un personatge que un usuari ha obtingut.
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         description: ID de l'usuari per obtenir les skins del personatge associades.
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Llista de skins trobades per a l'usuari.
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *       404:
 *         description: No s'han trobat skins per a aquest usuari.
 *       500:
 *         description: Error en la consulta.
 */
exports.getSkinsUsuari = async (req, res) => {
    try {
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .query(`
                SELECT s.*
                FROM SKINS s
                         JOIN PERSONATGES p ON s.personatge_id = p.id
                         JOIN BIBLIOTECA b ON p.id = b.personatge_id
                         JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'han trobat skins per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skin/user/{id}/{skin_id}:
 *   get:
 *     tags: [Skins]
 *     summary: Obtenir una skin específica d'un personatge per ID d'usuari
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
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('skin_id', sql.Int, req.params.skin_id)
            .query(`
                SELECT s.*
                FROM SKINS s
                         JOIN PERSONATGES p ON s.personatge_id = p.id
                         JOIN BIBLIOTECA b ON p.id = b.personatge_id
                         JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id AND s.id = @skin_id
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la skin per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skin/user/{id}/{nom}:
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
        const pool = await connectDB();
        const result = await pool.request()
            .input('id', sql.Int, req.params.id)
            .input('nom', sql.VarChar(50), req.params.nom)
            .query(`
                SELECT s.*
                FROM SKINS s
                         JOIN PERSONATGES p ON s.personatge_id = p.id
                         JOIN BIBLIOTECA b ON p.id = b.personatge_id
                         JOIN USUARIS u ON b.user_id = u.id
                WHERE u.id = @id AND s.nom = @nom
            `);
        res.send(result.recordset.length > 0 ? result.recordset : 'No s\'ha trobat la skin per a aquest usuari');
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la consulta');
    }
};

/**
 * @swagger
 * /skins:
 *   post:
 *     tags: [Skins]
 *     summary: Crear una nova skin
 *     description: Aquesta API permet afegir una nova skin a la base de dades.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nom:
 *                 type: string
 *               descripcio:
 *                 type: string
 *               personatge_id:
 *                 type: integer
 *     responses:
 *       201:
 *         description: Skin afegida correctament.
 *       500:
 *         description: Error en inserir la skin.
 */
exports.crearSkin = async (req, res) => {
    try {
        const { nom, descripcio, personatge_id } = req.body;
        const pool = await connectDB();
        await pool.request()
            .input('nom', sql.VarChar(50), nom)
            .input('descripcio', sql.VarChar(255), descripcio)
            .input('personatge_id', sql.Int, personatge_id)
            .query(`
                INSERT INTO SKINS (nom, descripcio, personatge_id)
                VALUES (@nom, @descripcio, @personatge_id)
            `);
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
        const pool = await connectDB();
        const skinId = req.params.id;

        const deleteResult = await pool.request()
            .input('id', sql.Int, skinId)
            .query('DELETE FROM SKINS WHERE id = @id');

        if (deleteResult.rowsAffected[0] === 0) {
            return res.status(404).send('Skin no trobada');
        }

        await pool.request()
            .input('skinId', sql.VarChar, skinId)
            .query(`
                UPDATE BIBLIOTECA
                SET skin_ids = REPLACE(
                    REPLACE(
                        REPLACE(skin_ids, ',' + @skinId, ''), 
                        @skinId + ',', ''
                    ), 
                    @skinId, ''
                )
                WHERE skin_ids LIKE '%' + @skinId + '%';
            `);

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
            return res.status(400).send('Email no proporcionado.');
        }

        const pool = await connectDB();
        const userRecord = await pool.request()
            .input('email', sql.VarChar(255), email)
            .query('SELECT id FROM USUARIS WHERE email = @email');

        if (userRecord.recordset.length === 0) {
            return res.status(400).send('No se encuentra un usuario con ese correo electrónico.');
        }

        const userId = userRecord.recordset[0].id;

        const userBalance = await pool.request()
            .input('userId', sql.Int, userId)
            .query('SELECT punts_emmagatzemats FROM USUARIS WHERE id = @userId');

        if (userBalance.recordset.length === 0 || userBalance.recordset[0].punts_emmagatzemats < 100) {
            return res.status(400).send('No tienes suficientes monedas para hacer el tiro.');
        }

        await pool.request()
            .input('userId', sql.Int, userId)
            .input('newBalance', sql.Int, userBalance.recordset[0].punts_emmagatzemats - 100)
            .query('UPDATE USUARIS SET punts_emmagatzemats = @newBalance WHERE id = @userId');

        // Obtenir totes les skins disponibles, excloent les dels personatges enemics excepte si tenen "bo" al nom
        const availableSkins = await pool.request()
            .query(`
                SELECT *
                FROM SKINS s
                WHERE NOT EXISTS (SELECT 1
                                  FROM ENEMICS e
                                  WHERE e.personatge_id = s.personatge)
                   OR s.nom LIKE '%bo%' -- Incloure les skins que tenen "bo" al nom, encara que el personatge sigui un enemic
            `);

        if (availableSkins.recordset.length === 0) {
            return res.status(400).send('No hay skins disponibles.');
        }

        const randomSkin = availableSkins.recordset[Math.floor(Math.random() * availableSkins.recordset.length)];

        const userSkins = await pool.request()
            .input('userId', sql.Int, userId)
            .input('personatgeId', sql.Int, randomSkin.personatge)  // Filtrar por el ID del personaje
            .query('SELECT skin_ids FROM BIBLIOTECA WHERE user_id = @userId AND personatge_id = @personatgeId');

        let userSkinIds = userSkins.recordset.length > 0 ? userSkins.recordset[0].skin_ids.split(',') : [];

        if (userSkinIds.includes(randomSkin.id.toString())) {
            return res.status(200).send("Ya tienes esta skin.");
        }

        userSkinIds.push(randomSkin.id);

        const updatedSkinIds = userSkinIds.join(',');

        if (userSkins.recordset.length === 0) {
            await pool.request()
                .input('userId', sql.Int, userId)
                .input('personatgeId', sql.Int, randomSkin.personatge)
                .input('updatedSkinIds', sql.NVarChar, updatedSkinIds)
                .input('date', sql.DateTime, new Date())
                .query(`
                    INSERT INTO BIBLIOTECA (user_id, personatge_id, data_obtencio, skin_ids)
                    VALUES (@userId, @personatgeId, @date, @updatedSkinIds)
                `);
        } else {
            await pool.request()
                .input('userId', sql.Int, userId)
                .input('personatgeId', sql.Int, randomSkin.personatge)
                .input('updatedSkinIds', sql.NVarChar, updatedSkinIds)
                .query(`
                    UPDATE BIBLIOTECA
                    SET skin_ids = @updatedSkinIds
                    WHERE user_id = @userId
                      AND personatge_id = @personatgeId
                `);
        }

        res.status(200).send({
            message: '¡Tirada de gacha realizada con éxito!',
            skin: randomSkin,
            remainingCoins: userBalance.recordset[0].punts_emmagatzemats - 100,
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error en la tirada de gacha');
    }
};

exports.seleccionarSkinAleatoria = async (req, res) => {
    try {
        const pool = await connectDB(); // Connexió a la base de dades

        // 1. Obtenir totes les skins disponibles per als enemics
        const resultSkins = await pool.request()
            .query(`
                SELECT s.id,
                       s.nom,
                       s.categoria,
                       s.imatge,
                       e.punts_donats,
                       s.personatge,
                       p.nom       AS nom_personatge,
                       p.vida_base AS vida_personatge
                FROM SKINS s
                         INNER JOIN PERSONATGES p ON s.personatge = p.id
                         INNER JOIN ENEMICS e ON e.personatge_id = p.id
                WHERE s.nom NOT LIKE '%bo%' -- Excloure les skins amb "bo" al nom
            `);

        if (resultSkins.recordset.length === 0) {
            return res.status(404).send('No hi ha skins disponibles per als enemics');
        }

        const skinsDisponibles = resultSkins.recordset; // Llista de skins disponibles

        // 2. Seleccionar una skin aleatòria
        const skinAleatoria = skinsDisponibles[Math.floor(Math.random() * skinsDisponibles.length)];

        // 3. Obtenir el mal base del personatge
        const resultMalBase = await pool.request()
            .input('personatge_id', sql.Int, skinAleatoria.personatge)
            .query(`
                SELECT mal_base
                FROM PERSONATGES
                WHERE id = @personatge_id
            `);

        if (resultMalBase.recordset.length === 0) {
            return res.status(404).send('Personatge no trobat');
        }

        const malBase = resultMalBase.recordset[0].mal_base; // Mal base del personatge

        // 4. Calcular el mal total (només mal_base, ja que no hi ha armes)
        const malTotal = malBase;

        // 5. Retornar les dades de la skin, el mal total i la vida del personatge
        res.status(200).json({
            skin: {
                id: skinAleatoria.id,
                nom: skinAleatoria.nom,
                categoria: skinAleatoria.categoria,
                imatge: skinAleatoria.imatge,
                punts_donats: skinAleatoria.punts_donats, // Punts que dona l'enemic
                mal_total: malTotal,
                personatge_nom: skinAleatoria.nom_personatge, // Nom del personatge associat
                vida: skinAleatoria.vida_personatge // Vida del personatge associat
            },
        });
    } catch (err) {
        console.error(err);
        res.status(500).send('Error en el servidor');
    }
}

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
        const pool = await connectDB();
        const userId = req.params.id;

        // Obtener los personajes del usuario
        const personatgesResult = await pool.request()
            .input('userId', sql.Int, userId)
            .query(`
                SELECT DISTINCT p.id  AS personatge_id,
                                p.nom AS personatge_nom,
                                p.vida_base,
                                p.mal_base
                FROM PERSONATGES p
                         JOIN BIBLIOTECA b ON p.id = b.personatge_id
                WHERE b.user_id = @userId
            `);

        if (personatgesResult.recordset.length === 0) {
            return res.status(404).send('No s\'han trobat personatges per a aquest usuari');
        }

        const personatges = personatgesResult.recordset;
        const personatgeIds = personatges.map(p => p.personatge_id);

        // Obtener las skins en una sola consulta
        const skinsResult = await pool.request()
            .input('userId', sql.Int, userId)
            .query(`
                SELECT s.id         AS skin_id,
                       s.nom        AS skin_nom,
                       s.categoria,
                       s.imatge,
                       a.mal        AS mal_arma,
                       a.nom        AS atac_nom,  -- Afegir el nom de l'atac
                       ar.buff_atac AS atac,
                       b.personatge_id
                FROM SKINS s
                         JOIN BIBLIOTECA b ON s.id IN (SELECT value FROM STRING_SPLIT(b.skin_ids, ','))
                         LEFT JOIN skins_armes sa ON s.id = sa.skin
                         LEFT JOIN ARMES ar ON sa.arma = ar.id
                         LEFT JOIN ATACS a ON s.atac = a.id
                WHERE b.user_id = @userId
            `);

        // Agrupar las skins por personaje
        const skinsPerPersonatge = {};
        skinsResult.recordset.forEach(skin => {
            if (!skinsPerPersonatge[skin.personatge_id]) {
                skinsPerPersonatge[skin.personatge_id] = [];
            }
            skinsPerPersonatge[skin.personatge_id].push(skin);
        });

        // Construir la respuesta final
        const personatgesAmbSkins = personatges.map(personatge => {
            const skins = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
                id: skin.skin_id,
                nom: skin.skin_nom,
                imatge: skin.imatge,
                categoria: skin.categoria,
                mal_total: personatge.mal_base + (skin.mal_arma || 0) + (skin.atac || 0),
                vida: personatge.vida_base,
                atac_nom: skin.atac_nom  // Afegir el nom de l'atac
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
        const pool = await connectDB();

        // 1. Obtenir tots els personatges enemics
        const personatgesResult = await pool.request()
            .query(`
                SELECT DISTINCT p.id AS personatge_id, p.nom AS personatge_nom,
                                p.vida_base, p.mal_base
                FROM PERSONATGES p
                         JOIN ENEMICS e ON p.id = e.personatge_id
            `);

        if (personatgesResult.recordset.length === 0) {
            return res.status(404).send('No s\'han trobat personatges enemics');
        }

        const personatges = personatgesResult.recordset;
        const personatgeIds = personatges.map(p => p.personatge_id);

        // 2. Obtenir totes les skins dels personatges enemics, excloent les que tenen "bo" al nom
        const skinsResult = await pool.request()
            .query(`
                SELECT s.id AS skin_id, s.nom AS skin_nom, s.categoria, s.imatge,
                       s.personatge AS personatge_id
                FROM SKINS s
                WHERE s.personatge IN (${personatgeIds.join(',')})
                  AND s.nom NOT LIKE '%Bo%'
            `);

        // 3. Agrupar les skins per personatge
        const skinsPerPersonatge = {};
        skinsResult.recordset.forEach(skin => {
            if (!skinsPerPersonatge[skin.personatge_id]) {
                skinsPerPersonatge[skin.personatge_id] = [];
            }
            skinsPerPersonatge[skin.personatge_id].push(skin);
        });

        // 4. Construir la resposta final
        const personatgesAmbSkins = personatges.map(personatge => {
            const skins = (skinsPerPersonatge[personatge.personatge_id] || []).map(skin => ({
                id: skin.skin_id,
                nom: skin.skin_nom,
                imatge: skin.imatge,
                categoria: skin.categoria,
                mal_total: personatge.mal_base + (skin.mal_arma || 0) + (skin.atac || 0)
            }));

            return {
                personatge: {
                    id: personatge.personatge_id,
                    nom: personatge.personatge_nom,
                    vida_base: personatge.vida_base,
                    mal_base: personatge.mal_base,
                    imatge: personatge.imatge,
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


















