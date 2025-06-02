import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class UltimateAnimation extends StatefulWidget {
  final String imageAsset;
  final String audioAsset;
  final VoidCallback onCompleted;

  const UltimateAnimation({
    required this.imageAsset,
    required this.audioAsset,
    required this.onCompleted,
    Key? key,
  }) : super(key: key);

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

    _controller.forward();
    _playAudioAndAnimate();
  }

  Future<void> _playAudioAndAnimate() async {
    try {
      await _audioPlayer.setSource(AssetSource(widget.audioAsset));
      Duration? duration = await _audioPlayer.getDuration();

      if (duration == null) {
        duration = const Duration(seconds: 5);
      }

      await _audioPlayer.resume();
      await Future.delayed(duration);

      await _controller.reverse();
      widget.onCompleted();
    } catch (e) {
      print("Error reproduciendo audio: $e");
      await _controller.reverse();
      widget.onCompleted();
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

    return WillPopScope(
      onWillPop: () async => false, // ❌ Desactiva el botó enrere
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: OverflowBox(
              maxWidth: maxWidth * 1.5,
              child: Transform.scale(
                scaleX: 1.4,
                scaleY: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    widget.imageAsset,
                    width: maxWidth,
                    height: scaledHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
