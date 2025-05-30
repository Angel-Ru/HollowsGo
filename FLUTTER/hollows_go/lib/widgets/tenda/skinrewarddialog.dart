import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dialog_content.dart';
import 'dialog_animations.dart';
import 'escritor_tinta.dart';
import 'slash_clipper.dart';
import 'special_animacio_service.dart';
import '../../service/videoservice.dart';

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

class _SkinRewardDialogState extends State<SkinRewardDialog>
    with TickerProviderStateMixin {
  String _fullBankaiText = "Bankai";

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
  late AnimationController _videoFadeOutController;
  late DialogAnimationManager _animations;

  late final bool _isShinji;

  @override
  void initState() {
    super.initState();

    _isShinji = _detectIsShinji(widget.skin);
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
    _videoFadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startBankaiThenVideo();
  }

  bool _detectIsShinji(Map<String, dynamic>? skin) {
    final videoPath = skin?['video_especial'] ?? '';
    final segments = videoPath.split('/');
    if (segments.length >= 3) {
      final folder = segments[2].toLowerCase();
      return folder == 'shinji';
    }
    return false;
  }

  Future<void> _startBankaiThenVideo() async {
    final String? videoPath = widget.skin?['video_especial'];

    if (videoPath == null || videoPath.isEmpty) {
      setState(() {
        _showBankaiScreen = false;
        _showDialogContent = true;
      });
      _animations.playEntryAnimation();
      return;
    }

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
  }

  Future<void> _playBankaiAudioWithTyping() async {
    final config = SpecialAnimationService.getConfigForSkin(widget.skin ?? {});
    if (config == null) {
      setState(() {
        _showBankaiScreen = false;
        _showDialogContent = true;
      });
      _animations.playEntryAnimation();
      return;
    }

    await _audioPlayer.setSource(AssetSource(config.audioAsset));
    _fullBankaiText = config.bankaiText;

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

    final result = await VideoService.initAssetVideo(
      assetPath: videoPath,
      onVideoEnd: () {
        _videoFadeOutController.forward().then((_) {
          setState(() {
            _showDialogContent = true;
          });
          _animations.playEntryAnimation();
        });
      },
      autoPlay: true,
      looping: false,
      showControls: false,
      allowFullScreen: false,
    );

    if (result != null) {
      _videoController = result.videoController;
      _chewieController = result.chewieController;

      setState(() {
        _isVideoReady = true;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    VideoService.disposeControllers(
      videoController: _videoController,
      chewieController: _chewieController,
    );
    _writeController.dispose();
    _fadeOutController.dispose();
    _slashController.dispose();
    _videoFadeOutController.dispose();
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
                              opacity: Tween<double>(begin: 1, end: 0)
                                  .animate(_fadeOutController),
                              child: Center(
                                child: AnimatedBuilder(
                                  animation: _writeController,
                                  builder: (context, child) {
                                    return SizedBox(
                                      width: dialogWidth,
                                      height: dialogHeight,
                                      child: CustomPaint(
                                        painter: InkWritePainter(
                                          text: _fullBankaiText,
                                          progress: _writeController.value,
                                          isShinji: _isShinji,
                                          textStyle: const TextStyle(
                                            fontSize: 64,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 8,
                                            fontFamily: 'Harukaze',
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
                                    clipper:
                                        SlashClipper(_slashController.value),
                                    child: child,
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: FadeTransition(
                                    opacity: Tween<double>(begin: 1.0, end: 0.0)
                                        .animate(_videoFadeOutController),
                                    child:
                                        Chewie(controller: _chewieController!),
                                  ),
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
