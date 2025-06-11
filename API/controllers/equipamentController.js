const { connectDB, sql } = require('../config/dbConfig');


exports.getArmesPredefinidesPerSkin = async (req, res) => {
  try {
    const { skin_id, usuari_id } = req.params;
    const connection = await connectDB();

    // 1️⃣ Obtenir les armes associades a la skin
    const [armesTotals] = await connection.execute(`
      SELECT a.id, a.nom, a.categoria, a.buff_atac
      FROM SKINS_ARMES sa
      JOIN ARMES a ON sa.arma = a.id
      WHERE sa.skin = ?
    `, [skin_id]);

    if (armesTotals.length === 0) {
      return res.status(404).send('No s’han trobat armes per a aquesta skin.');
    }

    // 2️⃣ Filtrar les armes amb TOTES les missions completades
    const armesCompletades = [];

    for (const arma of armesTotals) {
      const [missions] = await connection.execute(`
        SELECT um.progres, m.objectiu
        FROM MISSIONS_ARMES ma
        JOIN USUARIS_MISSIONS um ON ma.usuaris_missions_id = um.id
        JOIN MISSIONS m ON um.missio_id = m.id
        WHERE um.usuari_id = ? AND ma.arma_id = ?
      `, [usuari_id, arma.id]);

      // Totes les missions estan completades?
      const totesCompletades = missions.length > 0 &&
        missions.every(m => Number(m.progres) >= Number(m.objectiu));

      if (totesCompletades) {
        armesCompletades.push(arma);
      }
    }

    // 3️⃣ Obtenir l’arma equipada per l’usuari i la skin
    const [armaEquipadaRows] = await connection.execute(`
      SELECT a.id, a.nom, a.categoria, a.buff_atac
      FROM USUARI_SKIN_ARMES usa
      JOIN ARMES a ON usa.arma = a.id
      WHERE usa.usuari = ? AND usa.skin = ? AND usa.seleccionat = 1
    `, [usuari_id, skin_id]);

    const armaEquipada = armaEquipadaRows.length > 0 ? armaEquipadaRows[0] : null;

    // 4️⃣ Retornar resposta
    return res.status(200).json({
      armesPredefinides: armesCompletades,
      armaEquipada,
    });

  } catch (err) {
    console.error(err);
    res.status(500).send("Error en obtenir les armes predefinides.");
  }
};



exports.equiparArmaASkin = async (req, res) => {
    try {
        const { usuari_id, skin_id, arma_id } = req.body;
        const connection = await connectDB();

        const [validArma] = await connection.execute(
            'SELECT 1 FROM SKINS_ARMES WHERE skin = ? AND arma = ?',
            [skin_id, arma_id]
        );

        if (validArma.length === 0) {
            return res.status(400).send('Aquesta arma no és vàlida per a aquesta skin.');
        }

        const [existing] = await connection.execute(
            'SELECT 1 FROM USUARI_SKIN_ARMES WHERE usuari = ? AND skin = ?',
            [usuari_id, skin_id]
        );

        if (existing.length > 0) {
            await connection.execute(
                'UPDATE USUARI_SKIN_ARMES SET arma = ? WHERE usuari = ? AND skin = ?',
                [arma_id, usuari_id, skin_id]
            );
        } else {
            // Fem l'insert
            await connection.execute(
                'INSERT INTO USUARI_SKIN_ARMES (usuari, skin, arma) VALUES (?, ?, ?)',
                [usuari_id, skin_id, arma_id]
            );

            // Obtenim la vida_base del personatge associat a la skin
            const [result] = await connection.execute(
                `SELECT p.vida_base
                 FROM SKINS s
                 JOIN PERSONATGES p ON s.personatge = p.id
                 WHERE s.id = ?`,
                [skin_id]
            );

            if (result.length > 0) {
                const vidaBase = result[0].vida_base;

                // Suposant que USUARI_SKIN_ARMES té una columna vida_actual
                await connection.execute(
                    `UPDATE USUARI_SKIN_ARMES
                     SET vida_actual = ?
                     WHERE usuari = ? AND skin = ?`,
                    [vidaBase, usuari_id, skin_id]
                );
            }
        }

        res.status(200).json({ message: "Arma equipada correctament a la skin." });
    } catch (err) {
        console.error(err);
        res.status(500).send("Error en equipar l'arma.");
    }
};


exports.getVialsUsuari = async (req, res) => {
  try {
    const { usuari_id } = req.params;
    const connection = await connectDB();

    const [rows] = await connection.execute(
      'SELECT vials, ultima_actualitzacio FROM USUARI_VIALS WHERE usuari = ?',
      [usuari_id]
    );

    if (rows.length === 0) {
      
      await connection.execute(
        'INSERT INTO USUARI_VIALS (usuari, vials, ultima_actualitzacio) VALUES (?, 3, NOW())',
        [usuari_id]
      );
      return res.status(200).json({ vials: 3 });
    }

    let { vials, ultima_actualitzacio } = rows[0];
    const lastDate = new Date(ultima_actualitzacio);
    const now = new Date();

    const diffMs = now - lastDate;
    const hoursPassed = Math.floor(diffMs / (1000 * 60 * 60));
    const vialsToAdd = Math.floor(hoursPassed / 5);

    if (vials < 3 && vialsToAdd > 0) {
      const newVials = Math.min(3, vials + vialsToAdd);
      const newDate = new Date(lastDate.getTime() + vialsToAdd * 5 * 60 * 60 * 1000);

      await connection.execute(
        'UPDATE USUARI_VIALS SET vials = ?, ultima_actualitzacio = ? WHERE usuari = ?',
        [newVials, newDate, usuari_id]
      );

      vials = newVials;
    }

    return res.status(200).json({ vials });
  } catch (err) {
    console.error(err);
    res.status(500).send("Error en obtenir els vials.");
  }
};

exports.utilitzarVial = async (req, res) => {
  try {
    const { usuari_id, skin_id } = req.body;
    const connection = await connectDB();

    // 1. Comprovar vials disponibles
    const [vialRows] = await connection.execute(
      'SELECT vials, ultima_actualitzacio FROM USUARI_VIALS WHERE usuari = ?',
      [usuari_id]
    );

    if (vialRows.length === 0 || vialRows[0].vials <= 0) {
      return res.status(400).send("No tens vials disponibles.");
    }

    // 2. Obtenir personatge associat a la skin
    const [personatgeRows] = await connection.execute(
      `SELECT s.personatge
       FROM SKINS s
       WHERE s.id = ?`,
      [skin_id]
    );

    if (personatgeRows.length === 0) {
      return res.status(404).send("No s’ha trobat el personatge associat a la skin.");
    }

    const personatgeId = personatgeRows[0].personatge;

    // 3. Obtenir la vida base del personatge
    const [vidaRows] = await connection.execute(
      'SELECT vida_base FROM PERSONATGES WHERE id = ?',
      [personatgeId]
    );

    if (vidaRows.length === 0) {
      return res.status(404).send("No s’ha trobat la vida base del personatge.");
    }

    const vidaBase = vidaRows[0].vida_base;

    // 4. Actualitzar la vida_actual a la taula USUARI_SKIN_ARMES
    await connection.execute(
      `UPDATE USUARI_SKIN_ARMES
       SET vida_actual = ?
       WHERE usuari = ? AND skin = ?`,
      [vidaBase, usuari_id, skin_id]
    );

    // 5. Restar un vial i actualitzar la data
    const vials = vialRows[0].vials - 1;
    await connection.execute(
      'UPDATE USUARI_VIALS SET vials = ?, ultima_actualitzacio = ? WHERE usuari = ?',
      [vials, new Date(), usuari_id]
    );

    return res.status(200).json({
      message: "Vial utilitzat. Vida restaurada!",
      vialsRestants: vials,
      vida_actual: vidaBase
    });

  } catch (err) {
    console.error(err);
    res.status(500).send("Error en fer servir el vial.");
  }
};

