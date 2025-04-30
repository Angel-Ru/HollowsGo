import '../imports.dart';

/*
En aquesta classe es crea la pantalla de benvinguda de l'aplicació.
En aquesta pantalla mostren diferents animacions i unes imatges aleatòries d'en Kon.
Quan es toca la pantalla, es mostra el diàleg d'inici de sessió, en el qual et pots registrar o iniciar sessió.
*/

class PreHomeScreen extends StatefulWidget {
  @override
  _PreHomeScreenState createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen>
    with SingleTickerProviderStateMixin {
  // IMAGES OF KON FOR THE RANDOM IMAGE ARRAY
  final List<String> imagePaths = [
    'lib/images/prehomescreen_images/konbrillitos.png',
    'lib/images/prehomescreen_images/koncapitan.png',
    'lib/images/prehomescreen_images/konepico.png',
    'lib/images/prehomescreen_images/konlike.png',
    'lib/images/prehomescreen_images/konrap.png',
  ];

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollControllerTop;
  late ScrollController _scrollControllerBottom;
  late AudioPlayer _audioPlayer;

  // INICIALATE THE ANIMATION CONTROLLER AND THE SCROLL CONTROLLERS
  @override
  void initState() {
    super.initState();

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
        'https://res.cloudinary.com/dkcgsfcky/video/upload/v1745996030/MUSICA/fkgjkz7ttdqxqakacqsd.mp3'));
  }

  void _stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }

  // THIS FUNCTION IS FOR THE SCROLLING ANIMATION OF THE SKULLS + LOOPING
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

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
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
    // KON RANDOM IMAGE
    final random = Random();
    final randomImage = random.nextInt(imagePaths.length);

    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          _stopBackgroundMusic();
          _checkLogin();
          _showLoginDialog(context);
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: ListView.builder(
                    controller: _scrollControllerTop,
                    scrollDirection: Axis.horizontal,
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/prehomescreen_images/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Container(
                  height: 200,
                  child: Image.asset(
                    imagePaths[randomImage],
                    fit: BoxFit.cover,
                  ),
                ),
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
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 150),
                Container(
                  height: 40,
                  child: ListView.builder(
                    controller: _scrollControllerBottom,
                    scrollDirection: Axis.horizontal,
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/prehomescreen_images/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
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

  // lOGIN DIALOG METOD
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoginScreen();
      },
    );
  }
}
