import '../imports.dart';

class PreHomeScreen extends StatefulWidget {
  @override
  _PreHomeScreenState createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> imagePaths = [
    'lib/images/imatges_prehomescreen/0c7569c5931f07a4fbce4e1dd58f9684.jpg',
    'lib/images/imatges_prehomescreen/28bee056b92ef5af41ab8d7cc6f6949a.jpg',
    'lib/images/imatges_prehomescreen/47a6c1657d9d7a35d1e852d28cd2316c.jpg',
    'lib/images/imatges_prehomescreen/69c392ced882d589286c840dbfcac9cb.jpg',
    'lib/images/imatges_prehomescreen/73fa9d142edb2cde3417eecc0d15bfcb.jpg',
    'lib/images/imatges_prehomescreen/5951c02f2a2a74dea733a108549756f2.jpg',
    'lib/images/imatges_prehomescreen/a82b5790310afc901065789e507b584a.jpg',
    'lib/images/imatges_prehomescreen/a571d7d77159e05c9c35eaf4032c546b.jpg',
    'lib/images/imatges_prehomescreen/c7fbad03a224d0ee498ff8194ba14314.jpg',
    'lib/images/imatges_prehomescreen/c7285af40c27b635bab67680262bcd84.jpg',
  ];

  late String randomBackground;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollControllerTop;
  late ScrollController _scrollControllerBottom;
  late AudioPlayer _audioPlayer;

  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Selección aleatoria de fondo
    final random = Random();
    randomBackground = imagePaths[random.nextInt(imagePaths.length)];

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);

    _scrollControllerTop = ScrollController();
    _scrollControllerBottom = ScrollController();

    _startAutoScroll(_scrollControllerTop);
    _startAutoScroll(_scrollControllerBottom);

    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
  }

  void _playBackgroundMusic() async {
    await _audioPlayer.play(UrlSource(
      'https://res.cloudinary.com/dkcgsfcky/video/upload/v1745996030/MUSICA/fkgjkz7ttdqxqakacqsd.mp3',
    ));
  }

  Future<void> _pauseBackgroundMusic() async {
    _currentPosition = await _audioPlayer.getCurrentPosition() ?? Duration.zero;
    await _audioPlayer.pause();
  }

  Future<void> _resumeBackgroundMusic() async {
    await _audioPlayer.seek(_currentPosition);
    await _audioPlayer.resume();
  }

  Future<void> _stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }

  void _startAutoScroll(ScrollController scrollController) {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 20));
      if (scrollController.hasClients) {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;

        if (currentScroll >= maxScroll) {
          scrollController.jumpTo(0);
        } else {
          scrollController.animateTo(
            currentScroll + 15,
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
      return true;
    });
  }

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      await _stopBackgroundMusic();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollControllerTop.dispose();
    _scrollControllerBottom.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () async {
          await _pauseBackgroundMusic();
          bool wentToHome = await _checkLogin();
          if (!wentToHome) {
            await _showLoginDialog(context);
            await _resumeBackgroundMusic();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                randomBackground,
                fit: BoxFit.cover,
              ),
            ),
            // Capa oscura para mejorar contraste
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  SizedBox(height: 70),
                  AnimatedBuilder(
                    animation: _opacityAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Text(
                          "CLICA A ON SIGUI PER COMENÇAR",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 200),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Image.network(
                    "https://res.cloudinary.com/dkcgsfcky/image/upload/v1744708246/PREHOMESCREEN/ee9hwiaahvn6mj2dcnov.png",
                    width: 300,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLoginDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LoginScreen();
      },
    );

    if (result == true) {
      await _stopBackgroundMusic();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      }
    } else {
      await _resumeBackgroundMusic();
    }
  }
}
