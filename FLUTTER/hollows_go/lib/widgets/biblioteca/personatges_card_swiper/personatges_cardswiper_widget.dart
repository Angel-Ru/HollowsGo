import '../../../imports.dart';
import '../../healthbarwidget.dart';
import 'skin_interaccions.dart';

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
  late final SkinInteractionController _skinController;
  int _currentPage = 0;
  final Map<int, double?> _vidaPerSkin = {};

  bool _animarBarraVida = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65);
    _pageController.addListener(_onPageChanged);

    _skinController = SkinInteractionController(
      context: context,
      isEnemyMode: widget.isEnemyMode,
      usuariId: Provider.of<UserProvider>(context, listen: false).userId,
    );

    _loadVidaPerSkinsAroundPage(_currentPage);
  }

  void _onPageChanged() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
      _loadVidaPerSkinsAroundPage(newPage);
    }
  }

  Future<void> _loadVidaPerSkinsAroundPage(int page) async {
    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    final skins = widget.personatge.skins;

    final indices = [page];
    if (page - 1 >= 0) indices.add(page - 1);
    if (page + 1 < skins.length) indices.add(page + 1);

    for (final i in indices) {
      final skin = skins[i];
      if (_vidaPerSkin.containsKey(skin.id)) continue;
      final vida = await combatProvider.fetchSkinVidaActual(skin.id);
      if (mounted) {
        setState(() {
          _vidaPerSkin[skin.id] = vida;
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
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

  Future<void> _toggleFavorite(UserProvider userProvider) async {
    await _skinController.togglePersonatgeFavorite(widget.personatge.id);
    setState(() {});
  }

  Future<void> _toggleFavoriteSkin(UserProvider userProvider, Skin skin) async {
    await _skinController.toggleSkinFavorite(skin);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final isFavorite =
        userProvider.personatgePreferitId == widget.personatge.id;
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
                    builder: (context) =>
                        DetailScreen(personatgeId: widget.personatge.id),
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
                      child: _buildSkinCardStyled(
                        skin,
                        isSkinSelected,
                        isSkinFavorite,
                        userProvider,
                      ),
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

  double _calculateMaxSkinCardHeight(List<Skin> skins) {
    return skins.fold<double>(0.0, (max, skin) {
      final nameLength = skin.nom.length;
      final lines = (nameLength / 20).ceil();
      final height = 160 + (lines * 16) + 36 + 16;
      return (height > max ? height : max).toDouble();
    });
  }

  Widget _buildSkinCardStyled(Skin skin, bool isSkinSelected,
      bool isSkinFavorite, UserProvider userProvider) {
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
          if (widget.selectedSkin?.id == skin.id &&
              widget.onSkinDeselected != null) {
            widget.onSkinDeselected!();
          }
        },
        onLongPress: () async {
          if (widget.isEnemyMode) return;
          await _skinController.showArmesDialog(skin);
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
                    child: CachedNetworkImage(
                      imageUrl: skin.imatge ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          'assets/loading/loading.gif',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error, color: Colors.redAccent)),
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
                        shadows: const [
                          Shadow(blurRadius: 4, color: Colors.black)
                        ],
                      ),
                    ),
                  ),
                  if (isSkinSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.check_circle,
                          color: _activeColor, size: 28),
                    ),
                  Positioned(
                    bottom: 60,
                    left: 8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        if (widget.isEnemyMode) return;
                        final novaVida =
                            await _skinController.useVialAndFetchHealth(skin);
                        if (novaVida != null) {
                          setState(() {
                            _vidaPerSkin[skin.id] = novaVida;
                            _animarBarraVida = true;
                          });
                          Future.delayed(const Duration(milliseconds: 1100),
                              () {
                            setState(() {
                              _animarBarraVida = false;
                            });
                          });
                        }
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.healing, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
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
                                color: i < (skin.categoria ?? 0)
                                    ? Colors.yellow
                                    : Colors.grey,
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

    return Container(
      margin: const EdgeInsets.only(right: 8, top: 12),
      child: HealthBarWidget(
        currentHealth: vida,
        maxHealth: skin.vidaMaxima!,
        showText: false,
        isVertical: true,
      ),
    );
  }
}
