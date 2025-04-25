import 'package:flutter/material.dart';
import '../imports.dart';

class PersonatgesCardSwiper extends StatelessWidget {
  final Personatge personatge;
  final bool isEnemyMode;
  final Function(Skin) onSkinSelected;
  final Skin? selectedSkin;

  const PersonatgesCardSwiper({
    Key? key,
    required this.personatge,
    required this.isEnemyMode,
    required this.onSkinSelected,
    this.selectedSkin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del personaje
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            personatge.nom,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 10),

        // Swiper de skins
        SizedBox(
          height: 250,
          child: PageView.builder(
            itemCount: personatge.skins.length,
            controller: PageController(viewportFraction: 0.7),
            itemBuilder: (context, index) {
              final skin = personatge.skins[index];
              final isSkinSelected = selectedSkin?.id == skin.id;

              return _buildSkinCard(skin, isSkinSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkinCard(Skin skin, bool isSkinSelected) {
    return GestureDetector(
      onTap: isEnemyMode ? null : () => onSkinSelected(skin),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSkinSelected ? Colors.green : Colors.black,
                      width: isSkinSelected ? 4 : 2,
                    ),
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      skin.imatge ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                if (isSkinSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${skin.nom} (Mal: ${skin.malTotal})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  color: index < (skin.categoria ?? 0)
                      ? Colors.yellow
                      : Colors.grey,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
