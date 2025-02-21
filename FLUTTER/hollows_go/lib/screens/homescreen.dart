import 'package:hollows_go/imports.dart';
import 'package:hollows_go/providers/user_provider.dart';
import 'package:hollows_go/screens/mapscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _imagePath =
      'lib/images/perfil_predeterminat/perfil_predeterminat.jpg'; // Imatge per defecte
  final String _coinImagePath =
      'lib/images/kan_moneda.png'; // Ruta imatge moneda
  Timer? _timer;
  int _dialogIndex = 0;
  final List<String> _dialogues = [
    "Benvingut a HollowsGo!",
    "Getsuga... Tenshō!!",
    "Sóc un shinigami substitut, com que no saps què és?",
    "Si tens alguna pregunta, no dubtis en preguntar-me!",
  ];

  final List<String> _ichigoImages = [
    'lib/images/ichigo_character/ichigo_1.png',
    'lib/images/ichigo_character/ichigo_2.png',
    'lib/images/ichigo_character/ichigo_3.png',
    'lib/images/ichigo_character/ichigo_4.png',
    'lib/images/ichigo_character/ichigo_5.png',
  ];

  late String _currentImage;

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      _currentImage = (_ichigoImages..shuffle()).first;
    });
  }

  int _dialogIndex = 0;
  final List<String> _dialogues = [
    "Benvingut a HollowsGo!",
    "Getsuga... Tenshō!!",
    "Sóc un shinigami substitut, com que no saps què és?",
    "Si tens alguna pregunta, no dubtis en preguntar-me!",
  ];

  final List<String> _ichigoImages = [
    'lib/images/ichigo_character/ichigo_1.png',
    'lib/images/ichigo_character/ichigo_2.png',
    'lib/images/ichigo_character/ichigo_3.png',
    'lib/images/ichigo_character/ichigo_4.png',
    'lib/images/ichigo_character/ichigo_5.png',
  ];

  late String _currentImage;
  late String _previousImage;

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      String newImage;
      do {
        newImage = _ichigoImages[Random().nextInt(_ichigoImages.length)];
      } while (newImage == _currentImage);
      _previousImage = _currentImage;
      _currentImage = newImage;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfileImage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserPoints(); // Carrega inicial de punts
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        userProvider.fetchUserPoints(); // Actualitza cada 5 segons
      });
    });

    _currentImage = _ichigoImages[0];
  }

  @override
  void dispose() {
    _timer?.cancel(); // Para el timer quan es tanca la pantalla
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profileImagePath') ??
          'lib/images/perfil_predeterminat/perfil_predeterminat.jpg';
    });
  }

  Widget _getSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return Mapscreen(profileImagePath: _imagePath);
      case 2:
        return TendaScreen();
      case 3:
        return BibliotecaScreen();
      default:
        return Center(child: Text(''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(_coinImagePath),
                    ),
                    SizedBox(width: 8),
                    Text('${userProvider.coinCount}'),
                  ],
                ),
                Row(
                  children: [
                    Text(userProvider.username),
                    SizedBox(width: 8),
                    PopupMenuButton(
                      offset: Offset(0, 50),
                      icon: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(_imagePath),
                      ),
                      itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.image),
                              SizedBox(width: 8),
                              Text('Canviar imatge de perfil'),
                            ],
                          ),
                          onTap: () => _pickImage(context),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(width: 8),
                              Text('Configuració'),
                            ],
                          ),
                          onTap: () {
                            // Implementar configuració
                          },
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.logout),
                              SizedBox(width: 8),
                              Text('Surt'),
                            ],
                          ),
                          onTap: () => _logout(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/images/homescreen_image.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              'lib/images/bleach-rukia.gif',
              width: 200,
              height: 200,
            ),
          ),
          if (uiProvider.selectedMenuOpt == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: _nextDialogue,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(_currentImage),
                          backgroundColor: Color.fromARGB(255, 239, 178, 24),
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
                                  color:
                                      const Color.fromARGB(243, 194, 194, 194),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Kurosaki Ichigo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(211, 247, 160, 39),
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
          _getSelectedScreen(uiProvider.selectedMenuOpt),
        ],
      ),
      body: _getSelectedScreen(uiProvider.selectedMenuOpt),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Tenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Biblioteca',
          ),
        ],
        currentIndex: uiProvider.selectedMenuOpt,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          uiProvider.selectedMenuOpt = index;
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageSelectionPage(
          onImageSelected: (String imagePath) {
            setState(() {
              _imagePath = imagePath;
            });
            Navigator.of(context).pop(imagePath);
          },
        ),
      ),
    ).then((imagePath) async {
      if (imagePath != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', _imagePath);
      }
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PreHomeScreen()),
    );
  }
}
