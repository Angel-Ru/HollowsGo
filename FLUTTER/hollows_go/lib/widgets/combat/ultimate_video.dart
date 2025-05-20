import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UltimateVideo extends StatefulWidget {
  final String videoAsset;
  final VoidCallback onVideoEnd;

  const UltimateVideo({
    required this.videoAsset,
    required this.onVideoEnd,
    Key? key,
  }) : super(key: key);

  @override
  _UltimateVideoScreenState createState() => _UltimateVideoScreenState();
}

class _UltimateVideoScreenState extends State<UltimateVideo> {
  late VideoPlayerController _controller;
  bool _videoEnded = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (!_videoEnded &&
        _controller.value.position >= _controller.value.duration &&
        !_controller.value.isPlaying) {
      _videoEnded = true;
      widget.onVideoEnd();
      Navigator.of(context).pop(); // Salir de la pantalla
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
