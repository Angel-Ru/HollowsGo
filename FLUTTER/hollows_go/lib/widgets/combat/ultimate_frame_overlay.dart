/*import 'package:hollows_go/imports.dart';

class UltimateFrameOverlay extends StatefulWidget {
  @override
  _UltimateFrameOverlayState createState() => _UltimateFrameOverlayState();
}

class _UltimateFrameOverlayState extends State<UltimateFrameOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // Empieza fuera de pantalla a la derecha
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tamaño fijo según imagen original
    final double bannerWidth = 1080;
    final double bannerHeight = 400;

    return Material(
      color: Colors.black.withOpacity(0.3), // Fondo semitransparente
      child: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              width: bannerWidth,
              height: bannerHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/special_attack/shinji/marco_prova.png',
                  fit: BoxFit.none, // Mantiene tamaño original sin escalar
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
