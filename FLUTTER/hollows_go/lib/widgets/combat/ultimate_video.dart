import 'package:hollows_go/imports.dart';

class UltimateVideo extends StatefulWidget {
  final String videoAsset;
  final VoidCallback onVideoEnd;

  const UltimateVideo({
    required this.videoAsset,
    required this.onVideoEnd,
    Key? key,
  }) : super(key: key);

  @override
  _UltimateVideoPlayerScreenState createState() =>
      _UltimateVideoPlayerScreenState();
}

class _UltimateVideoPlayerScreenState extends State<UltimateVideo> {
  late VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _startListeners();
      });
  }

  void _startListeners() {
    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_navigated) {
        _navigated = true;
        widget.onVideoEnd();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
