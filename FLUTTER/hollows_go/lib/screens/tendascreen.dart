import 'package:hollows_go/imports.dart';

class TendaScreen extends StatefulWidget {
  @override
  _TendaScreenState createState() => _TendaScreenState();
}

class _TendaScreenState extends State<TendaScreen> {
  int _dialogIndex = 0;
  final List<String> _dialogues = [
    "Hola, sóc l'Urahara, i sigues benvingut a la tenda!",
    "Aquí podràs fer les diverses tirades al gatxa.",
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

  @override
  void initState() {
    super.initState();
    _currentImage = _uraharaImages[0];
  }

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      _currentImage = _uraharaImages[Random().nextInt(_uraharaImages.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Deshabilitar la flecha de retroceso
        title: null, // Quitar el título
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
                    backgroundColor: Color.fromARGB(255, 151, 250, 173)),
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
