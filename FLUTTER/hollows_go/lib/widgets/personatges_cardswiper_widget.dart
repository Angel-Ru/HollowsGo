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
  final Map<int, double?> _vidaPerSkin = {};

  // Flag per controlar si la barra ha d'animar-se
  bool _animarBarraVida = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    _loadVidaPerSkins();
  }

  Future<void> _loadVidaPerSkins() async {
    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    for (final skin in widget.personatge.skins) {
      final vida = await combatProvider.fetchSkinVidaActual(skin.id);
      setState(() {
        _vidaPerSkin[skin.id] = vida;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color get _activeColor => Colors.orangeAccent;
  Color get _borderColor => _activeColor.withOpacity(0.6);

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
                    builder: (context) => DetailScreen(personatgeId: widget.personatge.id),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: _buildSkinCardStyled(skin, isSkinSelected, isSkinFavorite, userProvider),
                    ),
                    const SizedBox(width: 4),
                    _buildBarraVida(skin.id),
                  ],
                ),
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
      final height = 160 + (lines * 16) + 36 + 16;
      return (height > max ? height : max).toDouble();
    });
  }

  Widget _buildSkinCardStyled(Skin skin, bool isSkinSelected, bool isSkinFavorite, UserProvider userProvider) {
    final displayName = _cleanSkinName(skin.nom, widget.personatge.nom);

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: GestureDetector(
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
                  if (isSkinSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.check_circle, color: _activeColor, size: 28),
                    ),
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
                        if (success) {
                          // Activar animació de la barra
                          setState(() {
                            _animarBarraVida = true;
                          });

                          // Tornem a carregar la vida actual de la skin
                          final combatProvider = Provider.of<CombatProvider>(context, listen: false);
                          final novaVida = await combatProvider.fetchSkinVidaActual(skin.id);

                          setState(() {
                            _vidaPerSkin[skin.id] = novaVida;
                            if (widget.selectedSkin?.id != skin.id) {
                              widget.onSkinSelected(skin);
                            }
                          });

                          // Desactivar animació després que acabi (1s)
                          Future.delayed(const Duration(milliseconds: 1100), () {
                            setState(() {
                              _animarBarraVida = false;
                            });
                          });
                        }
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
                        child: const Icon(Icons.local_hospital, color: Colors.white, size: 26),
                      ),
                    ),
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
      ),
    );
  }

  Widget _buildBarraVida(int skinId) {
    final vida = _vidaPerSkin[skinId];
    Skin? skin;

    try {
      skin = widget.personatge.skins.firstWhere((s) => s.id == skinId);
    } catch (e) {
      skin = null;
    }

    if (vida == null || skin == null) {
      return const SizedBox(height: 160);
    }

    final double vidaMaxima = skin.vidaMaxima?.toDouble() ?? 100;
    final double percent = (vida / vidaMaxima).clamp(0.0, 1.0);

    Color barraColor;
    if (percent > 2 / 3) {
      barraColor = Colors.green;
    } else if (percent > 1 / 3) {
      barraColor = Colors.yellow;
    } else {
      barraColor = Colors.red;
    }

    Widget barraInterior = Container(
      decoration: BoxDecoration(
        color: barraColor,
        borderRadius: BorderRadius.circular(6),
      ),
    );

    return Container(
      width: 10,
      height: 160,
      margin: const EdgeInsets.only(right: 4, top: 12),
      decoration: BoxDecoration(
        color: percent > 0 ? Colors.grey.shade600 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _animarBarraVida
            ? TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: percent),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, animatedPercent, child) {
                  return FractionallySizedBox(
                    heightFactor: animatedPercent,
                    child: barraInterior,
                  );
                },
              )
            : FractionallySizedBox(
                heightFactor: percent,
                child: barraInterior,
              ),
      ),
    );
  }
}
