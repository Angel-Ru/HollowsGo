import '../imports.dart';
import '../service/audioservice.dart';
import 'dart:math';

class CombatIntroVideoScreen extends StatefulWidget {
  @override
  _CombatIntroVideoScreenState createState() => _CombatIntroVideoScreenState();
}

class _CombatIntroVideoScreenState extends State<CombatIntroVideoScreen> {
  late VideoPlayerController _videoController;
  bool _navigated = false;
  late Widget _combatScreen;

  final List<String> musiquesDies = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/DIA/l7lo9rvit62uevuq1kjh',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/DIA/pyz9ui8dwuabwxy8rhp5',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/DIA/i1mirsiqcplvyeu3rb3q',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/DIA/qmtewqyfdby1ixuo6ryh',
  ];

  final List<String> musiquesNit = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/NIT/og5jzlnjqjk2tvsufb5r',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/NIT/b45dpkn1ubhvttgga0vc',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/NIT/xdyqf4ljifpgwplkc7os',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/COMBATSCREEN/AUDIO/NIT/lnw8xjdeu60lwfjdqhjo',
  ];

  @override
  void initState() {
    super.initState();
    _combatScreen = CombatScreen();
    _inicitalitzarVideo();
  }

  void _inicitalitzarVideo() {
    _videoController =
        VideoPlayerController.asset('lib/videos/animacion_combate.mp4')
          ..initialize().then((_) {
            setState(() {});
            _videoController.play();
            _startListeners();
            _preloadCombatImages();
          });
  }

  void _startListeners() {
    _videoController.addListener(() async {
      if (_videoController.value.position >= _videoController.value.duration &&
          !_navigated) {
        _navigated = true;
        await _iniciarMusica();
        _navigateToCombat();
      }
    });
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
