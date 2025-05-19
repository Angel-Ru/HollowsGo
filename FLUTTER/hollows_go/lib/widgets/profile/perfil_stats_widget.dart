import '../../imports.dart';

class PerfilStats extends StatelessWidget {
  final int partidesJugades;
  final int partidesGuanyades;
  final int nombrePersonatges;
  final int nombreSkins;
  final String? personatgePreferitNom;
  final String? skinPreferidaImatge;

  const PerfilStats({
    Key? key,
    required this.partidesJugades,
    required this.partidesGuanyades,
    required this.nombrePersonatges,
    required this.nombreSkins,
    this.personatgePreferitNom,
    this.skinPreferidaImatge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildStatsHeader(),
          SizedBox(height: 5),
          _buildStatsContent(),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Partides',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Personatges',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftColumn(),
        _buildRightColumn(),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatItem('Jugades', partidesJugades.toString()),
          _buildStatItem('Guanyades', partidesGuanyades.toString()),
          SizedBox(height: 12),
          Text(
            'Preferits',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          if (personatgePreferitNom != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatLabel('Personatge preferit'),
                _buildStatValue(personatgePreferitNom!),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildStatItem('En possessió', nombrePersonatges.toString(),
              alignment: CrossAxisAlignment.end),
          _buildStatItem('Skins', nombreSkins.toString(),
              alignment: CrossAxisAlignment.end),
          SizedBox(height: 45),
          if (skinPreferidaImatge != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildStatLabel('Skin preferida'),
                SizedBox(height: 6),
                _buildSkinImage(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value,
      {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        _buildStatLabel(label),
        _buildStatValue(value),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildStatLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildStatValue(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSkinImage() {
    return Container(
      height: 130,
      width: 130,
      margin: EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(skinPreferidaImatge!),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
    );
  }
}
