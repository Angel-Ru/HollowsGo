import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:hollows_go/imports.dart';

class CombatIntroVideoScreen extends StatefulWidget {
  @override
  _CombatIntroVideoScreenState createState() => _CombatIntroVideoScreenState();
}

class _CombatIntroVideoScreenState extends State<CombatIntroVideoScreen> {
  late VideoPlayerController _videoController;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('lib/videos/animacion_combate.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _startListeners();
        _preloadCombatImages();
      });
  }

  void _startListeners() {
    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration && !_navigated) {
        _navigated = true;
        _navigateToCombat();
      }
    });
  }

  Future<void> _preloadCombatImages() async {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    try {
      await provider.selectRandomSkin();

      final aliat = provider.selectedSkinAliat ??
          provider.selectedSkinQuincy ??
          provider.selectedSkinEnemic;

      final enemic = provider.selectedSkin;

      final aliatImageUrl = aliat?.imatge ?? 'lib/images/combatscreen_images/bleach_combat.png';
      final enemicImageUrl = enemic?.imatge ?? 'lib/images/combatscreen_images/aizen_combat.png';

      await precacheImage(NetworkImage(aliatImageUrl), context);
      await precacheImage(NetworkImage(enemicImageUrl), context);

      for (int i = 1; i <= 5; i++) {
        final backgroundPath = 'lib/images/combatscreen_images/fondo_combat_$i.png';
        await precacheImage(AssetImage(backgroundPath), context);
      }

    } catch (e) {
      print('Error precargando imágenes: $e');
    }
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
            : SizedBox.shrink(), 
      ),
    );
  }
}
