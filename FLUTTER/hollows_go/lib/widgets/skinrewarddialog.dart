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

  late AnimationController _fadeOutStarsController;
  late Animation<double> _fadeOutStarsAnimation;

  late AnimationController _fadeInImageController;
  late Animation<double> _fadeInImageAnimation;

  bool _showStars = true;
  bool _showImage = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initVideo();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeOutStarsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeOutStarsAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutStarsController, curve: Curves.easeOut),
    );

    _fadeInImageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeInImageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeInImageController, curve: Curves.easeIn),
    );
  }

  Future<void> _initVideo() async {
    final videoPath = widget.skin?['video_especial'];

    if (videoPath == null || videoPath.isEmpty) {
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

      _videoController!.addListener(_videoListener);

      setState(() {
        _isVideoReady = true;
      });
    } catch (e) {
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
    _fadeOutStarsController.dispose();
    _fadeInImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final isDuplicate = widget.isDuplicate;

    final double dialogWidth = 440;
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
                ? Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12.withOpacity(0.7),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: Chewie(controller: _chewieController!),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildDialogContent(Map<String, dynamic>? skin, bool isDuplicate) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage('https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.8), width: 1),
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
          if (!isDuplicate) ...[
            if (_showStars)
              FadeTransition(
                opacity: _fadeOutStarsAnimation,
                child: AnimatedStarRow(
                  count: _getStarCount(skin),
                  onCompleted: () async {
                    await _fadeOutStarsController.forward();
                    if (!mounted) return;
                    setState(() {
                      _showStars = false;
                      _showImage = true;
                    });
                    await _fadeInImageController.forward();
                  },
                ),
              ),
            if (_showImage)
              FadeTransition(
                opacity: _fadeInImageAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _getBorderColor(skin),
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            skin?['imatge'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
              'Ja tens aquesta skin.\nSe ha retornat el cost del gacha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orangeAccent.shade200,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Color _getBorderColor(Map<String, dynamic>? skin) {
    if (skin == null) return Colors.grey;

    if (skin['habilitat_llegendaria'] == true) {
      return Colors.amber.shade400;
    }

    switch (skin['categoria']) {
      case 1:
        return Colors.grey.shade400;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }

  int _getStarCount(Map<String, dynamic>? skin) {
    if (skin == null) return 0;
    if (skin['habilitat_llegendaria'] == true) return 5;
    return skin['categoria'] ?? 0;
  }
}

class AnimatedStarRow extends StatefulWidget {
  final int count;
  final VoidCallback? onCompleted;

  const AnimatedStarRow({required this.count, this.onCompleted, Key? key}) : super(key: key);

  @override
  State<AnimatedStarRow> createState() => _AnimatedStarRowState();
}

class _AnimatedStarRowState extends State<AnimatedStarRow> with TickerProviderStateMixin {
  late List<bool> _starVisible;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _starVisible = List.generate(widget.count, (_) => false);

    _controllers = List.generate(
      widget.count,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.5, end: 1.2)
          .chain(CurveTween(curve: Curves.elasticOut))
          .animate(controller);
    }).toList();

    _showStarsSequentially();
  }

  Future<void> _showStarsSequentially() async {
    for (int i = 0; i < widget.count; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      setState(() {
        _starVisible[i] = true;
      });
      _controllers[i].forward();
    }

    if (widget.onCompleted != null) {
      widget.onCompleted!();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.count, (index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _starVisible[index] ? 1.0 : 0.0,
          child: ScaleTransition(
            scale: _scaleAnimations[index],
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  colors: [
                    Colors.amber.shade700,
                    Colors.amber.shade300,
                    Colors.yellow.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect);
              },
              blendMode: BlendMode.srcATop,
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        );
      }),
    );
  }
}
