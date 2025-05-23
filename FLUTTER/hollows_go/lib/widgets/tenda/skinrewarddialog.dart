import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dialog_content.dart';
import 'dialog_animations.dart';

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
  final String _fullBankaiText = "Bankai";

  bool _showBankaiScreen = false;
  bool _bankaiWritten = false;
  bool _isVideoReady = false;
  bool _showDialogContent = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  late AnimationController _writeController;
  late AnimationController _fadeOutController;
  late AnimationController _slashController;
  late DialogAnimationManager _animations;

  @override
  void initState() {
    super.initState();

    _animations = DialogAnimationManager(vsync: this);

    _writeController = AnimationController(vsync: this);
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _startBankaiThenVideo();
  }

  Future<void> _startBankaiThenVideo() async {
    final String? videoPath = widget.skin?['video_especial'];

    if (videoPath == null || videoPath.isEmpty) {
      // No hi ha vídeo: no mostrar pantalla negra ni àudio, mostrar contingut directament
      setState(() {
        _showBankaiScreen = false;
        _showDialogContent = true;
      });
      _animations.playEntryAnimation();
      return;
    }

    // Hi ha vídeo: mostrar pantalla negra i reproduir àudio
    setState(() {
      _showBankaiScreen = true;
      _bankaiWritten = false;
    });

    await _playBankaiAudioWithTyping();

    setState(() {
      _bankaiWritten = true;
    });

    await _fadeOutController.forward();

    await _initVideo();

    await _slashController.forward();

    _videoController?.addListener(() {
      if (_videoController!.value.position >= _videoController!.value.duration) {
        setState(() {
          _showDialogContent = true;
        });
        _animations.playEntryAnimation();
      }
    });
  }

  Future<void> _playBankaiAudioWithTyping() async {
    await _audioPlayer.setSource(AssetSource('special_attack/yamamoto/yamamoto_aud.mp3'));

    Duration? duration;
    final completer = Completer<void>();
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
      completer.complete();
    });

    await Future.any([
      completer.future,
      Future.delayed(const Duration(seconds: 1)),
    ]);

    duration ??= const Duration(milliseconds: 1200);
    _writeController.duration = duration;
    _writeController.reset();
    _writeController.forward();
    await _audioPlayer.resume();
    await _audioPlayer.onPlayerComplete.first;
  }

  Future<void> _initVideo() async {
    final String? videoPath = widget.skin?['video_especial'];
    if (videoPath == null || videoPath.isEmpty) return;

    _videoController = VideoPlayerController.asset(videoPath);
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      showControls: false,
      allowFullScreen: false,
    );

    setState(() {
      _isVideoReady = true;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    _writeController.dispose();
    _fadeOutController.dispose();
    _slashController.dispose();
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double dialogWidth = 440;
    final double dialogHeight = dialogWidth * 9 / 16;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: SizedBox(
        width: dialogWidth,
        height: _showDialogContent ? null : dialogHeight,
        child: _showDialogContent
            ? FadeTransition(
                opacity: _animations.fadeAnimation,
                child: ScaleTransition(
                  scale: _animations.scaleAnimation,
                  child: DialogContent(
                    skin: widget.skin,
                    isDuplicate: widget.isDuplicate,
                    animations: _animations,
                  ),
                ),
              )
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _showBankaiScreen
                    ? SizedBox(
                        key: const ValueKey('bankai'),
                        width: dialogWidth,
                        height: dialogHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            FadeTransition(
                              opacity: Tween<double>(begin: 1, end: 0).animate(_fadeOutController),
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _writeController,
                                  builder: (context, child) {
                                    return SizedBox(
                                      width: dialogWidth,
                                      height: dialogHeight,
                                      child: CustomPaint(
                                        painter: _InkWritePainter(
                                          text: _fullBankaiText,
                                          progress: _writeController.value,
                                          textStyle: const TextStyle(
                                            fontSize: 64,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 8,
                                            fontFamily: 'Serif',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (_isVideoReady)
                              AnimatedBuilder(
                                animation: _slashController,
                                builder: (context, child) {
                                  return ClipPath(
                                    clipper: SlashClipper(_slashController.value),
                                    child: child,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Chewie(controller: _chewieController!),
                                ),
                              ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
      ),
    );
  }
}

class SlashClipper extends CustomClipper<Path> {
  final double progress;

  SlashClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final cutX = size.width * progress;
    final cutY = size.height * progress;

    path.moveTo(0, 0);
    path.lineTo(cutX, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, cutY);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SlashClipper oldClipper) => oldClipper.progress != progress;
}

class _InkWritePainter extends CustomPainter {
  final String text;
  final double progress;
  final TextStyle textStyle;

  _InkWritePainter({required this.text, required this.progress, required this.textStyle});

  @override
  void paint(Canvas canvas, Size size) {
    final characters = text.characters.toList();
    final countToShow = (characters.length * progress).floor();

    double totalWidth = 0;
    final visiblePainters = <TextPainter>[];

    for (int i = 0; i < characters.length; i++) {
      final isVisible = i < countToShow;
      final char = characters[i];

      final tp = TextPainter(
        text: TextSpan(
          text: char,
          style: textStyle.copyWith(
            color: isVisible ? textStyle.color : Colors.transparent,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      visiblePainters.add(tp);
      totalWidth += tp.width + (textStyle.letterSpacing ?? 0);
    }

    double x = (size.width - totalWidth) / 2;
    final y = (size.height - textStyle.fontSize!) / 2;

    for (final tp in visiblePainters) {
      tp.paint(canvas, Offset(x, y));
      x += tp.width + (textStyle.letterSpacing ?? 0);
    }
  }

  @override
  bool shouldRepaint(covariant _InkWritePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.text != text || oldDelegate.textStyle != textStyle;
  }
}
