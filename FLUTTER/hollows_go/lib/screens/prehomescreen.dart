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
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  // late AudioPlayer _audioPlayer;

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

    //_audioPlayer = AudioPlayer();
    //_playBackgroundMusic();
  }

  /* void _playBackgroundMusic() async {
    await _audioPlayer.play(AssetSource('../assets/Number_One.mp3'));
  }

  void _stopBackgroundMusic() async {
    await _audioPlayer.stop();
  }*/

  // THIS FUNCTION IS FOR THE SCROLLING ANIMATION OF THE SKULLS + LOOPING

  @override
  void dispose() {
    _controller.dispose();
    //_audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          //_stopBackgroundMusic();
          _showLoginDialog(context);
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  SizedBox(height: 70),
                  if (_opacityAnimation != null)
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
