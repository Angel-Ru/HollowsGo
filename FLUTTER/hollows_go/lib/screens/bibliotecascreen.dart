import 'package:hollows_go/imports.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  int _dialogIndex = 0;
  final List<String> _dialogues = [
    "Oh, quina sorpresa.",
    "Un altre ignorant en busca de coneixement?",
    "Benvingut al meu arxiu de meravelles...",
    "O potser hauria de dir, al teu infern de curiositat?",
    "Espero que hagis vingut a aprendre, i no només a perdre el temps.",
    "T’agradaria ser el meu pròxim subjecte d’experimentació?",
    "Els meus arxius contenen el que cap altre Shinigami gosaria investigar.",
    "Mmm... potser aquesta és una oportunitat per fer un experiment amb tu...",
  ];

  final List<String> _mayuriImages = [
    'lib/images/mayuri_character/mayuri_1.png',
    'lib/images/mayuri_character/mayuri_2.png',
    'lib/images/mayuri_character/mayuri_3.png',
    'lib/images/mayuri_character/mayuri_4.png',
    'lib/images/mayuri_character/mayuri_5.png',
    'lib/images/mayuri_character/mayuri_6.png',
    'lib/images/mayuri_character/mayuri_7.png',
    'lib/images/mayuri_character/mayuri_8.png',
  ];

  late String _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = _mayuriImages[0];
  }

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      _currentImage = _mayuriImages[Random().nextInt(_mayuriImages.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_currentImage),
                    backgroundColor: Color.fromARGB(255, 194, 149, 229)),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _nextDialogue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(243, 194, 194, 194),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Mayuri Kurotsuchi',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 249, 247, 77),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 194, 149, 229),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            _dialogues[_dialogIndex],
                            style: TextStyle(
                              fontSize: 14, // Tamaño de letra reducido
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
    );
  }
}
