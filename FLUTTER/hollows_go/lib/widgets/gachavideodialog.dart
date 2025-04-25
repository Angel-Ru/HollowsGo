import '../imports.dart';

class GachaVideoPopup extends StatefulWidget {
  final VoidCallback onVideoEnd;

  const GachaVideoPopup({required this.onVideoEnd, Key? key}) : super(key: key);

  @override
  _GachaVideoPopupState createState() => _GachaVideoPopupState();
}

class _GachaVideoPopupState extends State<GachaVideoPopup> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoController =
        VideoPlayerController.asset('lib/videos/animacion_gacha.mp4');
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
    );

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        Navigator.of(context).pop();
        widget.onVideoEnd();
      }
    });

    setState(() {}); // rebuild to show chewie
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black.withOpacity(0.7),
          dismissible: false,
        ),
        Center(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: (_videoController.value.isInitialized &&
                      _chewieController != null)
                  ? Chewie(controller: _chewieController)
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ],
    );
  }
}
