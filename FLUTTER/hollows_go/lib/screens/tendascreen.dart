import 'package:hollows_go/imports.dart';
import 'dart:convert'; // Para convertir la respuesta JSON
import 'package:http/http.dart' as http; // Para hacer peticiones HTTP

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
  bool _isLoading = false;  // Para controlar el estado de carga
  bool _imageLoaded = false;  // Para controlar cuando la imagen está cargada

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
    final email = prefs.getString('userEmail'); // Suponemos que el email está guardado como 'email'

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No se pudo obtener el correo del usuario!'),
      ));
      return;
    }

    setState(() {
      _isLoading = true; // Activamos la carga
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.197:3000/skins/gacha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}), // Enviamos el correo en el cuerpo de la petición
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final skin = data['skin'];
        final remainingCoins = data['remainingCoins'];

        // Cargamos la imagen de la skin antes de mostrar el dialog
        _loadImage(skin['imatge'], skin);

        // Mostrar la información de la tirada al usuario
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Has obtenido la skin: ${skin['nom']}! Monedas restantes: $remainingCoins'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.body}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error en la tirada de gacha: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false; // Desactivamos la carga
      });
    }
  }

  // Función para cargar la imagen antes de mostrar el diálogo
  void _loadImage(String imageUrl, Map<String, dynamic> skin) {
    final image = NetworkImage(imageUrl);
    final ImageStream stream = image.resolve(ImageConfiguration.empty);

    stream.addListener(
      ImageStreamListener((ImageInfo info, bool sync) {
        setState(() {
          _imageLoaded = true; // Marcamos la imagen como cargada
        });

        // Mostrar el diálogo cuando la imagen esté cargada
        if (_imageLoaded) {
          _showSkinDialog(skin);
        }
      }),
    );
  }

  // Función para mostrar el diálogo con la imagen y el texto de la skin obtenida
  void _showSkinDialog(Map<String, dynamic> skin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Has obtenido una nueva skin!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Aquí cargamos la imagen de la skin
              Image.network(skin['imatge'], width: 100, height: 100, fit: BoxFit.cover),
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
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/tenda_urahara.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _gachaPull, // Cuando se hace clic en el botón, ejecutamos la función _gachaPull
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
                                color: const Color.fromARGB(243, 194, 194, 194),
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
                                color: const Color.fromARGB(212, 238, 238, 238),
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
                // Si está cargando, mostramos el indicador de carga
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(), // Indicador de carga
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
