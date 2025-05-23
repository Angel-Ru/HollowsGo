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

class _PersonatgesCardSwiperState extends State<PersonatgesCardSwiper>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color get _activeColor => Colors.orangeAccent;

  Color get _borderColor => _activeColor.withOpacity(0.6);

  /// Retorna el nom de la skin sense la part coincident amb el nom del personatge a l'inici (case-insensitive)
  String _cleanSkinName(String skinName, String characterName) {
    if (skinName.toLowerCase().startsWith(characterName.toLowerCase())) {
      return skinName.substring(characterName.length).trim();
    }
    return skinName;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final isFavorite = userProvider.personatgePreferitId == widget.personatge.id;
    final maxHeight = _calculateMaxSkinCardHeight(widget.personatge.skins);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header amb nom, preferit i ajuda
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.personatge.nom,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _toggleFavorite(userProvider),
              child: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      personatgeId: widget.personatge.id,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.help_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: maxHeight,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.personatge.skins.length,
            itemBuilder: (context, index) {
              final skin = widget.personatge.skins[index];
              final isSkinSelected = widget.selectedSkin?.id == skin.id;
              final isSkinFavorite = userProvider.skinPreferidaId == skin.id;

              double scale = 1.0;
              if (_pageController.hasClients) {
                double page = _pageController.page ?? _currentPage.toDouble();
                scale = (1 - (page - index).abs() * 0.1).clamp(0.9, 1.0);
              }

              return Transform.scale(
                scale: scale,
                child: _buildSkinCardStyled(skin, isSkinSelected, isSkinFavorite, userProvider),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _toggleFavorite(UserProvider userProvider) async {
    final isCurrentlyFavorite = userProvider.personatgePreferitId == widget.personatge.id;
    final newId = isCurrentlyFavorite ? 0 : widget.personatge.id;
    await userProvider.updatePersonatgePreferit(newId);
  }

  Future<void> _toggleFavoriteSkin(UserProvider userProvider, Skin skin) async {
    final isCurrentlyFavorite = userProvider.skinPreferidaId == skin.id;
    final newId = isCurrentlyFavorite ? 0 : skin.id;
    await userProvider.updateSkinPreferida(newId);
    setState(() {});
  }

  double _calculateMaxSkinCardHeight(List<Skin> skins) {
    return skins.fold<double>(0.0, (max, skin) {
      final nameLength = skin.nom.length;
      final lines = (nameLength / 20).ceil();
      final height = 180 + (lines * 18) + 40 + 20; // 40 per botons curar+preferit
      return (height > max ? height : max).toDouble();
    });
  }

  Widget _buildSkinCardStyled(Skin skin, bool isSkinSelected, bool isSkinFavorite, UserProvider userProvider) {
    final displayName = _cleanSkinName(skin.nom, widget.personatge.nom);

    return GestureDetector(
      onTap: () {
        if (widget.isEnemyMode) return;
        if (widget.selectedSkin?.id != skin.id) {
          widget.onSkinSelected(skin);
        }
      },
      onDoubleTap: () {
        if (widget.isEnemyMode) return;
        if (widget.selectedSkin?.id == skin.id && widget.onSkinDeselected != null) {
          widget.onSkinDeselected!();
        }
      },
      onLongPress: () async {
        if (widget.isEnemyMode) return;
        final armesProvider = Provider.of<ArmesProvider>(context, listen: false);
        final usuariId = userProvider.userId;
        await mostrarDialegArmesPredefinides(
          context: context,
          skinId: skin.id,
          usuariId: usuariId,
          armesProvider: armesProvider,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[900],
            border: Border.all(
              color: isSkinSelected ? _activeColor : _borderColor,
              width: isSkinSelected ? 3 : 2,
            ),
            boxShadow: isSkinSelected
                ? [
                    BoxShadow(
                      color: _activeColor.withOpacity(0.7),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    skin.imatge ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error, color: Colors.redAccent)),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                // Botó preferit a la cantonada superior esquerra de la imatge
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavoriteSkin(userProvider, skin),
                    child: Icon(
                      isSkinFavorite ? Icons.star : Icons.star_border,
                      color: isSkinFavorite ? Colors.yellow : Colors.grey,
                      size: 28,
                      shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                ),

                // Botó curar a la cantonada inferior esquerra
                Positioned(
                  bottom: 60,
                  left: 8,
                  child: GestureDetector(
                    onTap: () async {
                      if (widget.isEnemyMode) return;
                      final success = await Provider.of<VialsProvider>(context, listen: false).utilitzarVial(
                        usuariId: userProvider.userId,
                        skinId: skin.id,
                      );
                      final snackBar = SnackBar(
                        content: Text(success ? 'Vial utilitzat per curar!' : 'No hi ha vials disponibles'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),

                if (isSkinSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.check_circle, color: _activeColor, size: 28),
                  ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayName.isEmpty ? skin.nom : displayName,
                          style: TextStyle(
                            color: _activeColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (i) {
                            return Icon(
                              Icons.star,
                              color: i < (skin.categoria ?? 0) ? Colors.yellow : Colors.grey,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}