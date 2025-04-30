import 'package:hollows_go/imports.dart';

class CombatIntroVideoScreen extends StatefulWidget {
  @override
  _CombatIntroVideoScreenState createState() => _CombatIntroVideoScreenState();
}

class _CombatIntroVideoScreenState extends State<CombatIntroVideoScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset('lib/videos/animacion_combate.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
          });

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        _navigateToCombat();
      }
    });
  }

  void _navigateToCombat() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CombatScreen()),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _videoController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
