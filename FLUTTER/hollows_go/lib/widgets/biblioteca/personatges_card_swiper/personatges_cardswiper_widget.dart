import '../../../imports.dart';
import '../../combat/healthbarwidget.dart';
import 'skin_card.dart';
import 'skin_interaccions.dart';
import 'skin_vida_controller.dart';

class PersonatgesCardSwiper extends StatefulWidget {
  final Personatge personatge;
  final Function(Skin) onSkinSelected;
  final Function()? onSkinDeselected;
  final Skin? selectedSkin;

  const PersonatgesCardSwiper({
    Key? key,
    required this.personatge,
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
  late final SkinHealthController _skinHealthController;

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.65);
    _pageController.addListener(_onPageChanged);

    _skinController = SkinInteractionController(
      context: context,
      usuariId: Provider.of<UserProvider>(context, listen: false).userId,
    );

    _skinHealthController = SkinHealthController(
      context: context,
      skinController: _skinController,
    );

    _skinHealthController.carregarVidaPerSkinsAroundPage(
      widget.personatge.skins,
      _currentPage,
    );
  }

  void _onPageChanged() {
    final newPage = _pageController.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
      _skinHealthController.carregarVidaPerSkinsAroundPage(
        widget.personatge.skins,
        newPage,
      );
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
                      child: SkinCard(
                        skin: skin,
                        isSelected: isSkinSelected,
                        isFavorite: isSkinFavorite,
                        onTap: () {
                          widget.onSkinSelected(skin);
                        },
                        onDoubleTap: () {
                          if (widget.onSkinDeselected != null) {
                            widget.onSkinDeselected!();
                          }
                        },
                        onLongPress: () async {
                          await _skinController.showArmesDialog(skin);
                        },
                        onVialPressed: () async {
                          final novaVida =
                              await _skinHealthController.usarVialISync(skin);
                          if (novaVida != null) {
                            setState(() {
                              _skinHealthController.animarBarraVida = true;
                            });
                            Future.delayed(const Duration(milliseconds: 1100),
                                () {
                              if (mounted) {
                                setState(() {
                                  _skinHealthController.animarBarraVida = false;
                                });
                              }
                            });
                          }
                        },
                        toggleSkinFavorite: () =>
                            _toggleFavoriteSkin(userProvider, skin),
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

  Widget _buildBarraVida(int skinId) {
    final vida = _skinHealthController.getVida(skinId);
    final Skin? skin = widget.personatge.skins.firstWhere(
      (s) => s.id == skinId,
      orElse: () => null as Skin,
    );

    if (vida == null || skin == null || skin.vidaMaxima == null) {
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
