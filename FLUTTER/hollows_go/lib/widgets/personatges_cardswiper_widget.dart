import '../imports.dart';

class PersonatgesCardSwiper extends StatefulWidget {
  final Personatge personatge;
  final bool isEnemyMode;
  final Function(Skin) onSkinSelected;
  final Function()? onSkinDeselected;
  final Skin? selectedSkin;

  const PersonatgesCardSwiper({
    Key? key,
    required this.personatge,
    required this.isEnemyMode,
    required this.onSkinSelected,
    this.onSkinDeselected,
    this.selectedSkin,
  }) : super(key: key);

  @override
  _PersonatgesCardSwiperState createState() => _PersonatgesCardSwiperState();
}

class _PersonatgesCardSwiperState extends State<PersonatgesCardSwiper> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isFavorite = userProvider.personatge?.id == widget.personatge.id;

    final maxHeight = _calculateMaxSkinCardHeight(widget.personatge.skins);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título del personaje con estrella
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.personatge.nom,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => _toggleFavorite(userProvider),
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Swiper de skins
        SizedBox(
          height: maxHeight,
          child: PageView.builder(
            itemCount: widget.personatge.skins.length,
            controller: PageController(viewportFraction: 0.7),
            itemBuilder: (context, index) {
              final skin = widget.personatge.skins[index];
              final isSkinSelected = widget.selectedSkin?.id == skin.id;

              return _buildSkinCard(skin, isSkinSelected);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _toggleFavorite(UserProvider userProvider) async {
    print('Toggling favorite for Personatge ID: ${widget.personatge.id}');
    if (userProvider.personatge?.id == widget.personatge.id) {
      // Si ya es favorito, lo desmarcamos
      await userProvider.updatepersonatgepreferit(null);
    } else {
      // Marcamos este personaje como favorito
      await userProvider.updatepersonatgepreferit(widget.personatge);
    }
  }

  double _calculateMaxSkinCardHeight(List<Skin> skins) {
    return skins.fold<double>(0.0, (max, skin) {
      final nameLength = skin.nom.length;
      final lines = (nameLength / 20).ceil();
      final height = 180 + (lines * 18) + 20 + 20;
      return height.toDouble() > max ? height.toDouble() : max;
    });
  }

  Widget _buildSkinCard(Skin skin, bool isSkinSelected) {
    return GestureDetector(
      onTap: () {
        if (widget.isEnemyMode) return;

        if (isSkinSelected) {
          return;
        } else {
          widget.onSkinSelected(skin);
        }
      },
      onDoubleTap: () {
        if (widget.isEnemyMode) return;

        if (isSkinSelected && widget.onSkinDeselected != null) {
          widget.onSkinDeselected!();
        }
      },
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
                4,
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
