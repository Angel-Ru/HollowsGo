import '../imports.dart';

class PreHomeScreen extends StatefulWidget {
  @override
  _PreHomeScreenState createState() => _PreHomeScreenState();
}

class _PreHomeScreenState extends State<PreHomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> imagePaths = [
    'lib/images/prehomescreen_imatges/koncapitan.png',
    'lib/images/prehomescreen_imatges/konepico.png',
    'lib/images/prehomescreen_imatges/konlike.png',
    'lib/images/prehomescreen_imatges/konbrillitos.png',
    'lib/images/prehomescreen_imatges/konrap.png',
  ];

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late ScrollController _scrollControllerTop;
  late ScrollController _scrollControllerBottom;

  @override
  void initState() {
    super.initState();

    // Configura el AnimationController para la animación de opacidad
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Configura la animación de opacidad
    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Repite la animación indefinidamente
    _controller.repeat(reverse: true);

    // Configura los ScrollController para el movimiento de las calaveras
    _scrollControllerTop = ScrollController();
    _scrollControllerBottom = ScrollController();

    // Inicia el movimiento automático de las calaveras
    _startAutoScroll(_scrollControllerTop);
    _startAutoScroll(_scrollControllerBottom);
  }

  void _startAutoScroll(ScrollController scrollController) {
    Future.doWhile(() async {
      await Future.delayed(
          Duration(milliseconds: 20)); // Velocidad del desplazamiento
      if (scrollController.hasClients) {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;

        if (currentScroll >= maxScroll) {
          // Reinicia el desplazamiento al inicio
          scrollController.jumpTo(0);
        } else {
          // Desplaza hacia la derecha
          scrollController.animateTo(
            currentScroll + 15, // Incremento del desplazamiento
            duration:
                Duration(milliseconds: 100), // Duración del desplazamiento
            curve: Curves.linear,
          );
        }
      }
      return true; // Repite indefinidamente
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollControllerTop.dispose();
    _scrollControllerBottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomImage = random.nextInt(imagePaths.length);

    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2), // Color lila claro de fondo
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          _showLoginDialog(
              context); // Mostrar el diálogo de login al tocar la pantalla
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Lista horizontal de calaveras en la parte superior
                Container(
                  height: 40,
                  child: ListView.builder(
                    controller: _scrollControllerTop,
                    scrollDirection: Axis.horizontal,
                    itemCount: 100, // Número grande para simular infinito
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/prehomescreen_imatges/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Spacer(), // Espacio flexible entre los widgets
                // Imagen aleatoria
                Container(
                  height: 200,
                  child: Image.asset(
                    imagePaths[randomImage],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 70), // Espacio fijo
                // Texto con animación de latido
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
                SizedBox(height: 150), // Espacio fijo
                // Lista horizontal de calaveras en la parte inferior
                Container(
                  height: 40,
                  child: ListView.builder(
                    controller: _scrollControllerBottom,
                    scrollDirection: Axis.horizontal,
                    itemCount: 100, // Número grande para simular infinito
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/prehomescreen_imatges/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Imagen centrada en la pantalla
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Image.asset(
                    "lib/images/prehomescreen_imatges/nom_aplicacio.png",
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

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoginScreen(); // Mostrar el LoginScreen como un diálogo
      },
    );
  }
}
