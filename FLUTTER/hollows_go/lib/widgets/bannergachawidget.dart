import 'package:flutter/material.dart';
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
  ];

  int _currentSetIndex = 0;
  int _currentBannerIndex = 0;
  late Timer _timer;
  final PageController _pageController = PageController();

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
        _currentBannerIndex = (_currentBannerIndex + 1) % _allBannerSets[_currentSetIndex].length;
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
    final gachaProvider = Provider.of<GachaProvider>(context, listen: false);
    final success = await gachaProvider.gachaPull(context);
    
    if (success) {
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
                        key: ValueKey(_allBannerSets[_currentSetIndex][_currentBannerIndex]),
                        _allBannerSets[_currentSetIndex][_currentBannerIndex],
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
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
        //Espai entre el banner i el botó de tirar el gacha(Ho he augmentat perque amb el tamany de banner més gross, no hi habia casi separació)
        const SizedBox(height: 30),
        
        ElevatedButton(
          onPressed: () => _handleGachaPull(context),
          child: Text(
            'Tirar Gacha',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..color = Color(0xFFFF6A13)
                ..style = PaintingStyle.stroke,
              shadows: const [
                Shadow(
                  offset: Offset(1.5, 1.5),
                  blurRadius: 3.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF8B400),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}