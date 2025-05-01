import '../imports.dart';

/*
L'ImageSelectionPage és una pàgina que permet seleccionar una imatge de perfil.
En aquesta classe s'hi pot arribar des del menú desplegable que surt quan es fa clic a la imatge de perfil de l'AppBar.
La imatge de perfil seleccionada es guarda a les Shared Preferences.
Per ajudar l'usuari a escollir una imatge, la pàgina mostra un diàleg amb en Kyoraku que et dona consells per a poder-ne escollir una.
*/

class ImageSelectionPage extends StatefulWidget {
  final Function(String) onImageSelected;

  ImageSelectionPage({super.key, required this.onImageSelected});

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  final List<String> imagePaths = [
    'lib/images/profile_photos/chad.png',
    'lib/images/profile_photos/kon.png',
    'lib/images/profile_photos/kenpachi.png',
    'lib/images/profile_photos/grimmjaw.png',
    'lib/images/profile_photos/komamura_goty.jpg',
    'lib/images/urahara_character/urahara_1.png',
    'lib/images/urahara_character/urahara_2.png',
    'lib/images/urahara_character/urahara_3.png',
    'lib/images/urahara_character/urahara_4.png',
    'lib/images/urahara_character/urahara_5.png',
    'lib/images/mayuri_character/mayuri_1.png',
    'lib/images/mayuri_character/mayuri_2.png',
    'lib/images/mayuri_character/mayuri_3.png',
    'lib/images/mayuri_character/mayuri_4.png',
    'lib/images/mayuri_character/mayuri_5.png',
    'lib/images/mayuri_character/mayuri_6.png',
    'lib/images/mayuri_character/mayuri_7.png',
    'lib/images/mayuri_character/mayuri_8.png',
    'lib/images/kyoraku_character/kyoraku_1.png',
    'lib/images/kyoraku_character/kyoraku_2.png',
    'lib/images/kyoraku_character/kyoraku_3.png',
    'lib/images/kyoraku_character/kyoraku_4.png',
    'lib/images/kyoraku_character/kyoraku_5.png',
  ];

  final List<String> _dialogues = [
    "Escollir perfil? Si vols, jo t’ajudo… amb una cervesa a la mà!",
    "Jo sempre escolliria un perfil amb més estil. Què me’n dius?",
    "Escollir perfil? Jo tinc una copa per cada opció. Tria la que més t’agradi.",
    "Molt bé, no cal pensar-hi tant… només escull el millor!",
  ];

  final List<String> _kyorakuImages = [
    'lib/images/kyoraku_character/kyoraku_1.png',
    'lib/images/kyoraku_character/kyoraku_2.png',
    'lib/images/kyoraku_character/kyoraku_3.png',
    'lib/images/kyoraku_character/kyoraku_4.png',
    'lib/images/kyoraku_character/kyoraku_5.png',
  ];

  int _dialogIndex = 0;
  late String _currentImage;
  late String _previousImage;

  @override
  void initState() {
    super.initState();
    _currentImage = _kyorakuImages[0];
  }

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      String newImage;
      do {
        newImage = _kyorakuImages[Random().nextInt(_kyorakuImages.length)];
      } while (newImage == _currentImage);
      _previousImage = _currentImage;
      _currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Selecciona una imatge'),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onImageSelected(imagePaths[index]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: _nextDialogue,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(_currentImage),
                        backgroundColor: Color.fromARGB(255, 245, 181, 234),
                      )),
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
                              'Shunsui Kyoraku',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 6, 7, 6),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 245, 181, 234),
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
            ),
          ],
        ),
      ),
    );
  }
}
