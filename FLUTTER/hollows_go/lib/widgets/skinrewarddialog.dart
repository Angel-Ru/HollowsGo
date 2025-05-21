import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SkinRewardDialog extends StatefulWidget {
  final Map<String, dynamic>? skin;
  final bool isDuplicate;

  const SkinRewardDialog({required this.skin, this.isDuplicate = false, Key? key})
      : super(key: key);

  @override
  State<SkinRewardDialog> createState() => _SkinRewardDialogState();
}

class _SkinRewardDialogState extends State<SkinRewardDialog>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  bool _showDialogContent = false;
  bool _videoReadyToPlay = false;

  double _videoVolume = 1.0;

  late AnimationController _animationController; // per diàleg
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _fadeOutVideoController; // per fade out vídeo
  late Animation<double> _videoFadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeOutVideoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _videoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutVideoController, curve: Curves.easeOut),
    );

    final videoUrl = widget.skin?['video_especial'];
    if (videoUrl != null) {
      _videoController = VideoPlayerController.asset(videoUrl)
        ..initialize().then((_) async {
          if (!mounted) return;

          setState(() {
            _videoReadyToPlay = true;
            _videoVolume = _videoController?.value.volume ?? 1.0;
          });

          _videoController?.play();
          _videoController?.addListener(_videoListener);
        });
    } else {
      _showDialogContent = true;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  void _videoListener() {
    if (_videoController == null || !_videoController!.value.isInitialized) return;

    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;
    final timeLeft = duration - position;

    // Pujar volum progressivament els darrers 2 segons
    if (timeLeft.inMilliseconds <= 2000) {
      final progress = 1 - (timeLeft.inMilliseconds / 2000);
      final currentVolume = _videoController!.value.volume;
      final newVolume = currentVolume + (1.0 - currentVolume) * progress;
      _videoVolume = newVolume.clamp(0.0, 1.0);
      _videoController?.setVolume(_videoVolume);
      setState(() {});
    }

    // Quan acaba el vídeo, iniciar fade out
    if (position >= duration && !_showDialogContent) {
      _startFadeOutVideo();
    }
  }

  void _startFadeOutVideo() {
    if (_showDialogContent) return;

    _fadeOutVideoController.forward().whenComplete(() {
      setState(() {
        _showDialogContent = true;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _animationController.dispose();
    _fadeOutVideoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final isDuplicate = widget.isDuplicate;

    final videoAspectRatio = _videoController?.value.isInitialized == true
        ? _videoController!.value.aspectRatio
        : 16 / 9;

    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!_showDialogContent)
            SizedBox(
              width: 300,
              height: 300 / videoAspectRatio,
              child: _videoReadyToPlay &&
                      _videoController != null &&
                      _videoController!.value.isInitialized
                  ? FadeTransition(
                      opacity: _videoFadeAnimation,
                      child: AspectRatio(
                        aspectRatio: videoAspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                  : Container(color: Colors.black),
            )
          else
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black54, BlendMode.darken),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.8),
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(minWidth: 300, minHeight: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isDuplicate ? '🔁 Skin Repetida! 🔁' : '🎉 Nova Skin Obtinguda!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade300,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (!isDuplicate)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            skin?['imatge'] ?? '',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (!isDuplicate) ...[
                        const Text(
                          'Has desbloquejat la skin:',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: ClipRect(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  ScaleAnimatedText(
                                    skin?['nom'] ?? '',
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                repeatForever: true,
                                pause: const Duration(milliseconds: 100),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (isDuplicate) ...[
                        Image.asset(
                          'lib/images/skinrepetida.gif',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Ja tens aquesta skin.\n Se ha retornat el cost del gacha',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ],
                      const SizedBox(height: 24),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.orangeAccent.shade200,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Acceptar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
