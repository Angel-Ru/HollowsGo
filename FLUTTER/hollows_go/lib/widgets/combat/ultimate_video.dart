import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../service/videoservice.dart';

class UltimateVideo extends StatefulWidget {
  final String videoAsset;
  final VoidCallback onVideoEnd;

  const UltimateVideo({
    required this.videoAsset,
    required this.onVideoEnd,
    Key? key,
  }) : super(key: key);

  @override
  State<UltimateVideo> createState() => _UltimateVideoState();
}

class _UltimateVideoState extends State<UltimateVideo> {
  VideoPlayerController? _videoController;
  bool _videoEnded = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final result = await VideoService.initAssetVideo(
      assetPath: widget.videoAsset,
      onVideoEnd: _handleVideoEnd,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
    );

    if (result != null) {
      setState(() {
        _videoController = result.videoController;
        _isInitialized = _videoController!.value.isInitialized;
      });
    }
  }

  void _handleVideoEnd() {
    if (!_videoEnded) {
      _videoEnded = true;
      widget.onVideoEnd();
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    VideoService.disposeControllers(videoController: _videoController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isInitialized
            ? Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
