import 'package:flutter/material.dart';
import 'package:hollows_go/widgets/multiskinrewarddialog.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../imports.dart';

class GachaBannerWidget extends StatefulWidget {
  const GachaBannerWidget({super.key});

  @override
  State<GachaBannerWidget> createState() => _GachaBannerWidgetState();
}

class _GachaBannerWidgetState extends State<GachaBannerWidget> {
  final List<List<String>> _allBannerSets = [
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/r1ak8j1is33rrshhvttw.png',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/dc8kvqgcrlrc0pglxy5h.png',
    ],
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641904/TENDASCREEN/lllx814oz39coei2qjw2.png',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/em78g2xplw170ms4opvj.png',
    ],
    [
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/esxiqu8zcrdka97pacvr.png',
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746706732/TENDASCREEN/luibwaplkahoyqhqdeyp.png'
    ]
  ];

  int _currentSetIndex = 0;
  int _currentBannerIndex = 0;
  late Timer _timer;
  final PageController _pageController = PageController();
  bool _isGachaLoading = false;

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
    setState(() {
      _isGachaLoading = true;
    });

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

    setState(() {
      _isGachaLoading = false;
    });
  }

  Future<void> _handleGachaPullMultiple(BuildContext context) async {
  setState(() {
    _isGachaLoading = true;
  });

  final gachaProvider = Provider.of<GachaProvider>(context, listen: false);
  late Future<bool> typePull;

  switch (_currentSetIndex) {
    case 0:
      typePull = gachaProvider.gachaPullMultiple(context);
      break;
    case 1:
      // typePull = gachaProvider.gachaPullQuincyMultiple(context);
      break;
    case 2:
      // typePull = gachaProvider.gachaPullEnemicsMultiple(context);
      break;
    default:
      setState(() {
        _isGachaLoading = false;
      });
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

  setState(() {
    _isGachaLoading = false;
  });
}



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragEnd: _handleSwipe,
          child: Stack(
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
                        key: ValueKey(
                            _allBannerSets[_currentSetIndex][_currentBannerIndex]),
                        _allBannerSets[_currentSetIndex][_currentBannerIndex],
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
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
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isGachaLoading ? null : () => _handleGachaPull(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8B400),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: _isGachaLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Tirar Gacha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _isGachaLoading ? null : () => _handleGachaPullMultiple(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEA82F),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: const Text(
                'Tirada x5',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
