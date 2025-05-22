import 'package:flutter/material.dart';
import 'dialog_video_player.dart';
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
  late final DialogAnimationManager _animations;
  bool _showDialogContent = false;
  bool _isVideoReady = false;

  @override
  void initState() {
    super.initState();
    _animations = DialogAnimationManager(vsync: this);
    _initVideo();
  }

  Future<void> _initVideo() async {
    final result = await DialogVideoPlayer.initVideo(
      skin: widget.skin,
      onVideoEnd: () {
        setState(() => _showDialogContent = true);
        _animations.playEntryAnimation();
      },
    );
    if (mounted) {
      setState(() {
        _isVideoReady = result.isReady;
        _showDialogContent = result.showContent;
      });
      if (_showDialogContent) {
        _animations.playEntryAnimation();
      }
    }
  }

  @override
  void dispose() {
    _animations.dispose();
    DialogVideoPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            : _isVideoReady
                ? DialogVideoPlayer.build()
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
