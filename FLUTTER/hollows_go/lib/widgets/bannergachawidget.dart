import '../imports.dart';

class GachaBannerWidget extends StatefulWidget {
  const GachaBannerWidget({super.key});

  @override
  State<GachaBannerWidget> createState() => _GachaBannerWidgetState();
}

class _GachaBannerWidgetState extends State<GachaBannerWidget> {
  final List<String> _bannerImages = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/r1ak8j1is33rrshhvttw.png',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1746641903/TENDASCREEN/dc8kvqgcrlrc0pglxy5h.png',
  ];
  
  int _currentBannerIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startBannerAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startBannerAnimation() {
    _timer = Timer.periodic(Duration(seconds: 8), (timer) {
      if (!mounted) return;
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _bannerImages.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final gachaProvider = Provider.of<GachaProvider>(context);

    return Column(
      children: [
        Transform.scale(
          scale: 1.2,
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
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AnimatedSwitcher(
                duration: Duration(seconds: 2),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    ),
                    child: child,
                  );
                },
                child: Image.network(
                  key: ValueKey<String>(_bannerImages[_currentBannerIndex]),
                  _bannerImages[_currentBannerIndex],
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
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
          },
          child: Text(
            'Tirar Gacha',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..color = Color(0xFFFF6A13)
                ..style = PaintingStyle.stroke,
              shadows: [
                Shadow(
                  offset: Offset(1.5, 1.5),
                  blurRadius: 3.0,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF8B400),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}