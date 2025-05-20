import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class UltimateAnimation extends StatefulWidget {
  final VoidCallback onCompleted; // callback para cuando la animación termine

  const UltimateAnimation({required this.onCompleted, Key? key})
      : super(key: key);

  @override
  _UltimateAnimationState createState() => _UltimateAnimationState();
}

class _UltimateAnimationState extends State<UltimateAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _playAudio();

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () async {
      await _controller.reverse();
      widget.onCompleted();
    });
  }

  Future<void> _playAudio() async {
    try {
      await _audioPlayer
          .play(AssetSource('special_attack/shinji/shinji_aud.mp3'));
    } catch (e) {
      print("Error reproduciendo audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.8;
    const originalWidth = 1080.0;
    const originalHeight = 400.0;

    final scaledHeight = (originalHeight / originalWidth) * maxWidth;

    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: OverflowBox(
            maxWidth:
                maxWidth * 1.5, // Permite un 50% más ancho que el contenedor
            child: Transform.scale(
              scaleX: 1.4, // Estira la imagen 40% en horizontal
              scaleY: 1.0, // No cambia la altura
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/special_attack/shinji/marco_shinji.png',
                  width: maxWidth,
                  height: scaledHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
