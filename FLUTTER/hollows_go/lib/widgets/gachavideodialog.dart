import '../imports.dart';

class GachaVideoPopup extends StatefulWidget {
  final VoidCallback onVideoEnd;

  const GachaVideoPopup({required this.onVideoEnd, Key? key}) : super(key: key);

  @override
  _GachaVideoPopupState createState() => _GachaVideoPopupState();
}

class _GachaVideoPopupState extends State<GachaVideoPopup> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final result = await VideoService.initAssetVideo(
      assetPath: 'lib/videos/animacion_gacha.mp4',
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
      onVideoEnd: () {
        Navigator.of(context).pop();
        widget.onVideoEnd();
      },
    );

    if (result != null) {
      _videoController = result.videoController;
      _chewieController = result.chewieController;
      setState(() {
        _isReady = true;
      });
    }
  }

  @override
  void dispose() {
    VideoService.disposeControllers(
      videoController: _videoController,
      chewieController: _chewieController,
    );
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async => false,
    child: Stack(
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
              child: (_isReady && _chewieController != null)
                  ? Chewie(controller: _chewieController!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _videoController?.pause();
              Navigator.of(context).pop();
              widget.onVideoEnd();
            },
            child: const Text("SKIP"),
          ),
        ),
      ],
    ),
  );
}

}
