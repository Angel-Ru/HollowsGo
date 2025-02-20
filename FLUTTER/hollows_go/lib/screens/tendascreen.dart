import 'package:hollows_go/imports.dart';
import 'dart:convert'; // Per convertir la resposta JSON
import 'package:http/http.dart' as http; // Per fer peticions HTTP

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
    // Obtenir el correu de les SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail'); // Suposem que l'email està emmagatzemat com 'email'

    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No es pot obtenir el correu de l\'usuari!'),
      ));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.197:3000/skins/gacha'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}), // Enviem l'email en el cos de la petició
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final skin = data['skin'];
        final remainingCoins = data['remainingCoins'];

        // Mostrar la informació de la tirada al usuari
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Has obtingut la skin: ${skin['nom']}! Monedes restants: $remainingCoins'),
        ));
      } else {
        // Si no té prou monedes o altres errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.body}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error en la tirada de gacha: $e'),
      ));
    }
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
                      onTap: _gachaPull, // Quan es clica el botó, s'executa la funció _gachaPull
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
