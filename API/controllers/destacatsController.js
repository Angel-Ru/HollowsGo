const { connectDB, sql } = require('../config/dbConfig');

exports.getSkinsCategoria4Raça1 = async (req, res) => {
  try {
    const connection = await connectDB();

    const [result] = await connection.execute(`
      SELECT s.nom, s.imatge
      FROM SKINS s
      WHERE s.raça = 1 AND s.categoria = 4
      ORDER BY s.nom
    `);

    if (result.length === 0) {
      return res.status(404).send('No s\'han trobat skins amb raça 1 i categoria 4');
    }

    res.status(200).json(result);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error en la consulta');
  }
};

exports.getSkinsCategoria4Raça0 = async (req, res) => {
  try {
    const connection = await connectDB();

    const [result] = await connection.execute(`
      SELECT s.nom, s.imatge
      FROM SKINS s
      WHERE s.raça = 0 AND s.categoria = 4
      ORDER BY s.nom
    `);

    if (result.length === 0) {
      return res.status(404).send('No s\'han trobat skins amb raça 1 i categoria 4');
    }

    res.status(200).json(result);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error en la consulta');
  }
};

exports.getSkinsCategoria4Raça2 = async (req, res) => {
  try {
    const connection = await connectDB();

    const [result] = await connection.execute(`
      SELECT s.nom, s.imatge
      FROM SKINS s
      WHERE s.raça = 2 AND s.categoria = 4
      ORDER BY s.nom
    `);

    if (result.length === 0) {
      return res.status(404).send('No s\'han trobat skins amb raça 1 i categoria 4');
    }

    res.status(200).json(result);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error en la consulta');
  }
};
