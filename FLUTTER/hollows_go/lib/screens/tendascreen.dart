import 'dart:ui';
import '../imports.dart';
import 'package:http/http.dart' as http;

class TendaScreen extends StatefulWidget {
  @override
  _TendaScreenState createState() => _TendaScreenState();
}

class _TendaScreenState extends State<TendaScreen> {
  bool _isLoading = false;
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _videoController = VideoPlayerController.network('');
    _chewieController =
        ChewieController(videoPlayerController: _videoController);
  }

  @override
  void dispose() {
    if (_videoController.value.isInitialized) {
      _videoController.dispose();
    }
    if (_chewieController.videoPlayerController.value.isInitialized) {
      _chewieController.dispose();
    }
    super.dispose();
  }

  Future<void> _gachaPull() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail');

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("No se ha pogut obtenir el correu de l'usuari!"),
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.28:3000/skins/gacha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final skin = data['skin'];
        final remainingCoins = data['remainingCoins'];

        await _showVideoPopup(skin);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Has obtingut la skin: ${skin['nom']}! Monedes restants: $remainingCoins'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.body}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error amb la tirada de gacha: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showVideoPopup(Map<String, dynamic> skin) async {
    try {
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
        if (_videoController.value.position >=
            _videoController.value.duration) {
          Navigator.of(context).pop();
          _showSkinDialog(skin);
        }
      });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
                    child: Chewie(controller: _chewieController),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al reproduir el vídeo: $e'),
      ));
    }
  }

  void _showSkinDialog(Map<String, dynamic> skin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Has obtingut una nueva skin!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(skin['imatge'],
                  width: 100, height: 100, fit: BoxFit.cover),
              SizedBox(height: 10),
              Text(
                'Skin: ${skin['nom']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tancar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Altura del AppBar
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10), // Efecto de desenfoque
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white
                  .withOpacity(0.5), // Fondo blanco semi-transparente
              elevation: 0, // Sin sombra
              title: null, // No hay título en el AppBar
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/tenda_urahara.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 150,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: Colors.grey[700]!.withOpacity(0.8), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/images/banner_gacha/banner.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.38,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _gachaPull,
                  child: Text(
                    'Tirar Gacha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..color = Color(0xFFFF6A13)
                        ..style = PaintingStyle.stroke,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8B400),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<DialogueProvider>(
              builder: (context, dialogueProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: dialogueProvider.nextDialogue,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage(dialogueProvider.currentImage),
                            backgroundColor: Color.fromARGB(255, 151, 250, 173),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: dialogueProvider.nextDialogue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(243, 194, 194, 194),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Kisuke Urahara',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(212, 238, 238, 238),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    dialogueProvider.currentDialogue,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_isLoading) Center(child: CircularProgressIndicator()),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
