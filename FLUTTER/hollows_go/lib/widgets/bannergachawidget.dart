import 'package:hollows_go/widgets/custom_loading_indicator.dart';
import 'package:hollows_go/widgets/multiskinrewarddialog.dart';
import '../imports.dart';
import 'tenda/skinsdestacats.dart';

class GachaBannerWidget extends StatefulWidget {
  const GachaBannerWidget({super.key});

  @override
  State<GachaBannerWidget> createState() => _GachaBannerWidgetState();
}

class _GachaBannerWidgetState extends State<GachaBannerWidget> {
  final List<List<String>> _allBannerSets = [
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/dc8kvqgcrlrc0pglxy5h',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/r1ak8j1is33rrshhvttw',
    ],
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/lllx814oz39coei2qjw2',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/em78g2xplw170ms4opvj',
    ],
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/esxiqu8zcrdka97pacvr',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/luibwaplkahoyqhqdeyp'
    ]
  ];

  int _currentSetIndex = 0;
  int _currentBannerIndex = 0;
  late Timer _timer;
  final PageController _pageController = PageController();
  bool _isGachaLoading = false;
  double _scaleSingle = 1.0;
  double _scaleMulti = 1.0;

  @override
  void initState() {
    super.initState();
    _startBannerRotation();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startBannerRotation() {
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;
      setState(() {
        _currentBannerIndex =
            (_currentBannerIndex + 1) % _allBannerSets[_currentSetIndex].length;
      });
    });
  }

  void _handleSwipe(DragEndDetails details) {
    if (!mounted) return;
    if (details.primaryVelocity! > 0) {
      _changeBannerSet((_currentSetIndex - 1) % _allBannerSets.length);
    } else if (details.primaryVelocity! < 0) {
      _changeBannerSet((_currentSetIndex + 1) % _allBannerSets.length);
    }
  }

  void _changeBannerSet(int newIndex) {
    if (newIndex < 0) newIndex = _allBannerSets.length - 1;
    if (newIndex >= _allBannerSets.length) newIndex = 0;
    if (_currentSetIndex == newIndex) return;

    setState(() {
      _currentSetIndex = newIndex;
      _currentBannerIndex = 0;
    });

    _timer.cancel();
    _startBannerRotation();
  }

  Future<void> _handleGachaPull(BuildContext context) async {
    setState(() => _isGachaLoading = true);
    final gachaProvider = Provider.of<GachaProvider>(context, listen: false);
    late Future<bool> typePull;

    switch (_currentSetIndex) {
      case 0:
        typePull = gachaProvider.gachaPull(context);
        break;
      case 1:
        typePull = gachaProvider.gachaPullQuincy(context);
        break;
      case 2:
        typePull = gachaProvider.gachaPullEnemics(context);
        break;
      default:
        return;
    }

    final success = await typePull;

    if (success) {
      final imageUrl = gachaProvider.latestSkin?['imatge'];
      if (imageUrl != null && imageUrl is String) {
        final image = NetworkImage(imageUrl);
        await precacheImage(image, context);
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => GachaVideoPopup(
          onVideoEnd: () {
            showDialog(
              context: context,
              builder: (_) => SkinRewardDialog(
                skin: gachaProvider.latestSkin,
                isDuplicate: gachaProvider.isDuplicateSkin,
              ),
            );
          },
        ),
      );
    }

    setState(() => _isGachaLoading = false);
  }

  Future<void> _handleGachaPullMultiple(BuildContext context) async {
    setState(() => _isGachaLoading = true);
    final gachaProvider = Provider.of<GachaProvider>(context, listen: false);
    late Future<bool> typePull;

    switch (_currentSetIndex) {
      case 0:
        typePull = gachaProvider.gachaPullMultiple(context);
        break;
      case 1:
        typePull = gachaProvider.gachaPullMultipleQuincys(context);
        break;
      case 2:
        typePull = gachaProvider.gachaPullMultipleEnemics(context);
        break;
      default:
        setState(() => _isGachaLoading = false);
        return;
    }

    final success = await typePull;

    if (success && gachaProvider.latestMultipleSkins.isNotEmpty) {
      final futures = gachaProvider.latestMultipleSkins.map((skin) async {
        final imageUrl = skin['imatge'];
        if (imageUrl != null && imageUrl is String) {
          try {
            await precacheImage(NetworkImage(imageUrl), context);
          } catch (e) {
            debugPrint('Error precargando imagen: $imageUrl, $e');
          }
        }
      }).toList();

      final videoDialog = showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => GachaVideoPopup(
          onVideoEnd: () {
            showDialog(
              context: context,
              builder: (_) => MultiSkinRewardDialog(
                results: gachaProvider.latestMultipleSkins,
              ),
            );
          },
        ),
      );

      await Future.wait([videoDialog, Future.wait(futures)]);
    }

    setState(() => _isGachaLoading = false);
  }

  Color getButtonColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFF9800);
      case 1:
        return const Color(0xFF2196F3);
      case 2:
        return const Color(0xFF550055);
      default:
        return Colors.grey;
    }
  }

  BorderSide getButtonBorder(int index) {
    return const BorderSide(color: Colors.black, width: 2);
  }

  TextStyle getTextStyle(int index) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  Widget animatedButtonWithImage({
    required String label,
    required String imageUrl,
    required VoidCallback onPressed,
    required double scale,
    required void Function(double) setScale,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() => setScale(0.9)),
      onTapUp: (_) => setState(() => setScale(1.0)),
      onTapCancel: () => setState(() => setScale(1.0)),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: getButtonColor(_currentSetIndex).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.fromBorderSide(getButtonBorder(_currentSetIndex)),
          ),
          child: ElevatedButton(
            onPressed: _isGachaLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  imageUrl,
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 30,
                      width: 30,
                      child: Center(child: CustomLoadingIndicator()),
                    );
                  },
                ),
                const SizedBox(width: 2),
                _isGachaLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CustomLoadingIndicator(),
                      )
                    : Text(
                        label,
                        style: getTextStyle(_currentSetIndex),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const buttonImageUrl =
        'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/OTHERS/yslqndyf4eri3f7mpl6i';

    return Column(
      children: [
        GestureDetector(
          onHorizontalDragEnd: _handleSwipe,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Transform.scale(
                scale: 1.3,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[700]!.withOpacity(0.8),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedSwitcher(
                      duration: const Duration(seconds: 2),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                        child: child,
                      ),
                      child: Image.network(
                        key: ValueKey(_allBannerSets[_currentSetIndex]
                            [_currentBannerIndex]),
                        _allBannerSets[_currentSetIndex][_currentBannerIndex],
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CustomLoadingIndicator());
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_allBannerSets.length, (index) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentSetIndex == index
                            ? Colors.white.withOpacity(0.9)
                            : Colors.white.withOpacity(0.4),
                      ),
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: -12,
                right: -12,
                child: GestureDetector(
                  onTap: () async {
                    final gachaProvider =
                        Provider.of<GachaProvider>(context, listen: false);

                    if (_currentSetIndex == 1) {
                      await gachaProvider.fetchSkinsCategoria4Quincy(context);
                    } else if (_currentSetIndex == 2) {
                      await gachaProvider.fetchSkinsCategoria4Hollows(context);
                    } else {
                      await gachaProvider
                          .fetchSkinsCategoria4Shinigamis(context);
                    }

                    if (!mounted) return;

                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(20),
                        child: SkinSwiperPopup(
                          skins: gachaProvider.publicSkins,
                          currentIndex: _currentSetIndex,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 2),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                          child: child,
                        ),
                        child: Image.network(
                          key: ValueKey(_currentSetIndex),
                          _currentSetIndex == 1
                              ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/wfobiwvsveiyqrb4suu6'
                              : _currentSetIndex == 2
                                  ? 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/uodrpjmettpywivmsnlt'
                                  : 'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/TENDASCREEN/isxsnqgs1nox2keiluef',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CustomLoadingIndicator());
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            animatedButtonWithImage(
              label: 'x100',
              imageUrl: buttonImageUrl,
              onPressed: () => _handleGachaPull(context),
              scale: _scaleSingle,
              setScale: (val) => _scaleSingle = val,
            ),
            const SizedBox(width: 15),
            animatedButtonWithImage(
              label: 'x500',
              imageUrl: buttonImageUrl,
              onPressed: () => _handleGachaPullMultiple(context),
              scale: _scaleMulti,
              setScale: (val) => _scaleMulti = val,
            ),
          ],
        ),
      ],
    );
  }
}
