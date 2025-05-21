import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SkinRewardDialog extends StatefulWidget {
  final Map<String, dynamic>? skin;
  final bool isDuplicate;

  const SkinRewardDialog({
    required this.skin,
    this.isDuplicate = false,
    Key? key,
  }) : super(key: key);

  @override
  State<SkinRewardDialog> createState() => _SkinRewardDialogState();
}

class _SkinRewardDialogState extends State<SkinRewardDialog> with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _showDialogContent = false;
  bool _isVideoReady = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initVideo();
  }

  void _setupAnimations() {
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

  Future<void> _initVideo() async {
    final videoPath = widget.skin?['video_especial'];

    if (videoPath == null || videoPath.isEmpty) {
      // Sense vídeo: mostrar directament el contingut
      setState(() {
        _showDialogContent = true;
      });
      _animationController.forward();
      return;
    }

    _videoController = VideoPlayerController.asset(videoPath);

    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        showControls: false,
        allowFullScreen: false,
      );

      // Escoltem quan acaba el vídeo
      _videoController!.addListener(_videoListener);

      setState(() {
        _isVideoReady = true;
      });
    } catch (e) {
      // Si falla la càrrega, mostrar el contingut
      setState(() {
        _showDialogContent = true;
      });
      _animationController.forward();
    }
  }

  void _videoListener() {
    if (_videoController == null || !_videoController!.value.isInitialized) return;

    final position = _videoController!.value.position;
    final duration = _videoController!.value.duration;

    if (position >= duration && !_showDialogContent) {
      setState(() {
        _showDialogContent = true;
      });
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _chewieController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final isDuplicate = widget.isDuplicate;

    final double dialogWidth = 400;
    final double dialogHeight = dialogWidth * 9 / 16;

    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.6),
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: dialogWidth,
        height: _showDialogContent ? null : dialogHeight,
        child: _showDialogContent
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildDialogContent(skin, isDuplicate),
                ),
              )
            : _isVideoReady
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildDialogContent(Map<String, dynamic>? skin, bool isDuplicate) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.8),
          width: 1,
        ),
      ),
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
                width: 240,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 10),
          if (!isDuplicate) ...[
            const Text(
              'Has desbloquejat la skin:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Center(
              child: SizedBox(
                height: 40,
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
          ],
          if (isDuplicate) ...[
            Image.asset(
              'lib/images/skinrepetida.gif',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'Ja tens aquesta skin.\n Se ha retornat el cost del gacha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
          const SizedBox(height: 24),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orangeAccent.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Acceptar',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
