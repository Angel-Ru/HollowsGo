import 'package:hollows_go/imports.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

class TendaScreen extends StatefulWidget {
  @override
  _TendaScreenState createState() => _TendaScreenState();
}

class _TendaScreenState extends State<TendaScreen> {
  int _dialogIndex = 0;
  final List<String> _dialogues = [
    "Hola, sóc l'Urahara, i sigues benvingut a la tenda!",
    "Aquí podràs fer les diverses tirades al gacha.",
    "Tens prou diners per una tirada?",
    "Em vaig a fer una becadeta...",
  ];

  final List<String> _uraharaImages = [
    'lib/images/urahara_character/urahara_1.png',
    'lib/images/urahara_character/urahara_2.png',
    'lib/images/urahara_character/urahara_3.png',
    'lib/images/urahara_character/urahara_4.png',
    'lib/images/urahara_character/urahara_5.png',
  ];

  late String _currentImage;
  late String _previousImage;
  bool _isLoading = false;
  bool _imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _currentImage = _uraharaImages[0];
    _previousImage = _currentImage;
  }

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      String newImage;
      do {
        newImage = _uraharaImages[Random().nextInt(_uraharaImages.length)];
      } while (newImage == _currentImage);
      _previousImage = _currentImage;
      _currentImage = newImage;
    });
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
        Uri.parse('http://192.168.228.168:3000/skins/gacha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final skin = data['skin'];
        final remainingCoins = data['remainingCoins'];

        _loadImage(skin['imatge'], skin);

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

  void _loadImage(String imageUrl, Map<String, dynamic> skin) {
    final image = NetworkImage(imageUrl);
    final ImageStream stream = image.resolve(ImageConfiguration.empty);

    stream.addListener(
      ImageStreamListener((ImageInfo info, bool sync) {
        setState(() {
          _imageLoaded = true;
        });

        if (_imageLoaded) {
          _showSkinDialog(skin);
        }
      }),
    );
  }

  void _showSkinDialog(Map<String, dynamic> skin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Has obtenido una nueva skin!'),
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
      appBar: AppBar(automaticallyImplyLeading: false, title: null),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/tenda_urahara.jpg',
              fit: BoxFit.cover,
            ),
          ),

          /// **Banner y Botón juntos**
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                /// **Banner**
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

                /// **Botón Tirar Gacha**
                ElevatedButton(
                  onPressed: _gachaPull,
                  child: Text(
                    'Tirar Gacha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..color = Color(0xFFFF6A13)
                        ..style = PaintingStyle.stroke, // Contorno amarillo
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
                    backgroundColor:
                        Color(0xFFF8B400), // Rojo oscuro para el fondo
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: Colors.black, width: 2), // Borde negro
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _nextDialogue,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(_currentImage),
                        backgroundColor: Color.fromARGB(255, 151, 250, 173),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: _nextDialogue,
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
                                _dialogues[_dialogIndex],
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
            ),
          ),
        ],
      ),
    );
  }
}
