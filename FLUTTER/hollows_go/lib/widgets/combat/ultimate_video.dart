import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UltimateVideo extends StatefulWidget {
  final String videoAsset;
  final VideoPlayerController? controller;
  final VoidCallback onVideoEnd;

  const UltimateVideo({
    required this.videoAsset,
    required this.onVideoEnd,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<UltimateVideo> createState() => _UltimateVideoState();
}

class _UltimateVideoState extends State<UltimateVideo> {
  late VideoPlayerController _videoController;
  bool _videoEnded = false;

  @override
  void initState() {
    super.initState();

    _videoController =
        widget.controller ?? VideoPlayerController.asset(widget.videoAsset);

    if (widget.controller == null) {
      _videoController.initialize().then((_) {
        setState(() {});
        _videoController.play();
        _startListeners();
      });
    } else {
      _videoController.play();
      _startListeners();
    }
  }

  void _startListeners() {
    _videoController.addListener(() {
      if (!_videoEnded &&
          _videoController.value.position >= _videoController.value.duration &&
          !_videoController.value.isPlaying) {
        _videoEnded = true;
        widget.onVideoEnd();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _videoController.value.isInitialized
            ? Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orangeAccent,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
