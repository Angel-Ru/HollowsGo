import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class UltimateVideo extends StatefulWidget {
  final VoidCallback onVideoEnd;

  const UltimateVideo({required this.onVideoEnd, Key? key}) : super(key: key);

  @override
  _UltimateVideoState createState() => _UltimateVideoState();
}

class _UltimateVideoState extends State<UltimateVideo> {
  late VideoPlayerController _videoController;
  bool _videoEnded = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
        'assets/special_attack/shinji/shinji_vid.mp4');

    _videoController.initialize().then((_) {
      setState(() {});
      _videoController.play();
    });

    _videoController.addListener(() {
      if (!_videoEnded &&
          _videoController.value.position >= _videoController.value.duration &&
          !_videoController.value.isPlaying) {
        _videoEnded = true;
        widget.onVideoEnd();
        Navigator.of(context).pop(); // Cierra el diálogo
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  if (!_videoController.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  return Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black, // Puedes ajustarlo según necesites
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orangeAccent,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      ),
    ),
  );
}
}
