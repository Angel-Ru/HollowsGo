import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../imports.dart';
import '../service/audioservice.dart';
import 'dart:math';
import '../widgets/tenda/dialog_animations.dart';

class CombatIntroVideoScreen extends StatefulWidget {
  @override
  _CombatIntroVideoScreenState createState() => _CombatIntroVideoScreenState();
}

class _CombatIntroVideoScreenState extends State<CombatIntroVideoScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _videoController;
  late DialogAnimationManager _animationManager;
  bool _navigated = false;
  bool _isVideoReady = false;

  final List<String> musiquesDies = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/DIA/COMBATSCREEN_AUDIO_DIA_l7lo9rvit62uevuq1kjh%20-%20copia.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/DIA/COMBATSCREEN_AUDIO_DIA_pyz9ui8dwuabwxy8rhp5%20-%20copia.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/DIA/COMBATSCREEN_AUDIO_DIA_i1mirsiqcplvyeu3rb3q%20-%20copia.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/DIA/qmtewqyfdby1ixuo6ryh.mp3',
  ];

  final List<String> musiquesNit = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/NIT/COMBATSCREEN_AUDIO_NIT_og5jzlnjqjk2tvsufb5r%20-%20copia.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/NIT/COMBATSCREEN_AUDIO_NIT_b45dpkn1ubhvttgga0vc%20-%20copia.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/NIT/xdyqf4ljifpgwplkc7os.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Combat_Screen/NIT/lnw8xjdeu60lwfjdqhjo.mp3',
  ];

  @override
  void initState() {
    super.initState();
    _animationManager = DialogAnimationManager(vsync: this);
    _initVideo();
  }

  Future<void> _initVideo() async {
    final result = await VideoService.initAssetVideo(
      assetPath: 'lib/videos/animacion_combate.mp4',
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
      onVideoEnd: () async {
        if (!_navigated) {
          _navigated = true;
          await _animationManager.fadeController.reverse();
          await _iniciarMusica();
          _navigateToCombat();
        }
      },
    );

    if (result != null) {
      _videoController = result.videoController;
      _isVideoReady = true;
      _animationManager.playEntryAnimation();
      _preloadCombatImages();
      setState(() {});
    }
  }

  Future<void> _iniciarMusica() async {
    final hora = DateTime.now().hour;
    final esDia = hora >= 7 && hora < 17;
    final musica = esDia ? musiquesDies : musiquesNit;
    final musicaAleatoria = musica[Random().nextInt(musica.length)];
    await AudioService.instance.play(musicaAleatoria);
  }

  Future<void> _preloadCombatImages() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    try {
      await provider.selectRandomSkin();
      final aliat = provider.selectedSkinAliat ??
          provider.selectedSkinQuincy ??
          provider.selectedSkinEnemic;
      final enemic = provider.selectedSkin;
      final aliatImageUrl =
          aliat?.imatge ?? 'lib/images/combatscreen_images/bleach_combat.png';
      final enemicImageUrl =
          enemic?.imatge ?? 'lib/images/combatscreen_images/aizen_combat.png';

      await precacheImage(NetworkImage(aliatImageUrl), context);
      await precacheImage(NetworkImage(enemicImageUrl), context);

      for (int i = 1; i <= 5; i++) {
        final backgroundPath =
            'lib/images/combatscreen_images/fondo_combat_$i.png';
        await precacheImage(AssetImage(backgroundPath), context);
      }
    } catch (e) {
      print('Error precargando imágenes: $e');
    }
  }

  void _navigateToCombat() async {
    final provider = Provider.of<CombatProvider>(context, listen: false);
    final skin =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false)
            .selectedSkin;
    final skinId = skin?.id;

    if (skinId != null) {
      await provider.fetchSkinVidaActual(skinId);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => CombatScreen()),
    );
  }

  @override
  void dispose() {
    VideoService.disposeControllers(videoController: _videoController);
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ❌ Evita que l'usuari pugui tornar enrere
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: (_isVideoReady &&
                  _videoController != null &&
                  _videoController!.value.isInitialized)
              ? FadeTransition(
                  opacity: _animationManager.fadeAnimation,
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
