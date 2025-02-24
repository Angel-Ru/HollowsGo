import 'dart:ui';
import 'package:hollows_go/imports.dart';
import 'package:hollows_go/providers/user_provider.dart';
import 'package:hollows_go/screens/mapscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _imagePath =
      'lib/images/perfil_predeterminat/perfil_predeterminat.jpg';
  final String _coinImagePath = 'lib/images/kan_moneda.png';
  Timer? _timer;
  int _dialogIndex = 0;
  final List<String> _dialoguesrukia = [
    "Si baixes la guardia, et podries trobar amb un Hollow.",
    "No et fies de ningú, ni tan sols de mi. Sóc un Shinigami, recorda-ho.",
    "La lluna esta hermosa aquesta nit, no creus?",
    "En Chappy el conillet es molt més bonic que tu",
    "Si tens algun problema, no dubtis en demanar ajuda.",
    "Recorda que el gachapon costa 100 monedes.",
  ];

  final List<String> _rukiaImages = List.generate(
      8, (index) => 'lib/images/rukia_character/rukia_${index + 1}.png');

  int _rukiaImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserPoints();
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        userProvider.fetchUserPoints();
      });

      // Mover la llamada a setDialogueData() fuera de initState() para evitar el error
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.setDialogueData(
        [
          "Benvingut a HollowsGo!",
          "Getsuga... Tenshō!!",
          "Sóc un shinigami substitut, com que no saps què és?",
          "Si tens alguna pregunta, no dubtis en preguntar-me!",
        ],
        [
          'lib/images/ichigo_character/ichigo_1.png',
          'lib/images/ichigo_character/ichigo_2.png',
          'lib/images/ichigo_character/ichigo_3.png',
          'lib/images/ichigo_character/ichigo_4.png',
          'lib/images/ichigo_character/ichigo_5.png',
        ],
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');

    // Establir la ruta de la imatge per defecte si no es troba una ruta vàlida
    setState(() {
      _imagePath = (imagePath != null && imagePath.isNotEmpty)
          ? imagePath
          : 'lib/images/perfil_predeterminat/perfil_predeterminat.jpg'; // Imatge per defecte
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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.5),
              elevation: 0,
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
          ),
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
          if (uiProvider.selectedMenuOpt == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<DialogueProvider>(
                builder: (context, dialogueProvider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: dialogueProvider.nextDialogue,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage(dialogueProvider.currentImage),
                              onBackgroundImageError: (exception, stackTrace) {
                                print(
                                    "L'imatge no se ha pogut carregar encara");
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 239, 178, 24),
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
                                      color: const Color.fromARGB(
                                          243, 194, 194, 194),
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
                                      color: const Color.fromARGB(
                                          211, 247, 160, 39),
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
                      // Diálogo de Rukia
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _dialogIndex = (_dialogIndex + 1) %
                                      _dialoguesrukia.length;
                                  _rukiaImageIndex = (_rukiaImageIndex + 1) %
                                      _rukiaImages.length;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          243, 194, 194, 194),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Kuchiki Rukia',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.8),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _dialoguesrukia[_dialogIndex],
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
                          SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _dialogIndex =
                                    (_dialogIndex + 1) % _dialoguesrukia.length;
                                _rukiaImageIndex = (_rukiaImageIndex + 1) %
                                    _rukiaImages.length;
                              });
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage(_rukiaImages[_rukiaImageIndex]),
                              onBackgroundImageError: (exception, stackTrace) {
                                print(
                                    "L'imatge no se ha pogut carregar encara");
                              },
                              backgroundColor:
                                  Color.fromARGB(255, 24, 121, 239),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          _getSelectedScreen(uiProvider.selectedMenuOpt),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent, // BottomNavigationBar translúcido
        elevation: 0, // Sin sombra
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
          final dialogueProvider =
              Provider.of<DialogueProvider>(context, listen: false);

          if (index == 0) {
            // HomeScreen
            dialogueProvider.setDialogueData(
              [
                "Benvingut a HollowsGo!",
                "Getsuga... Tenshō!!",
                "Sóc un shinigami substitut, com que no saps què és?",
                "Si tens alguna pregunta, no dubtis en preguntar-me!",
              ],
              [
                'lib/images/ichigo_character/ichigo_1.png',
                'lib/images/ichigo_character/ichigo_2.png',
                'lib/images/ichigo_character/ichigo_3.png',
                'lib/images/ichigo_character/ichigo_4.png',
                'lib/images/ichigo_character/ichigo_5.png',
              ],
            );
          } else if (index == 2) {
            // TendaScreen
            dialogueProvider.setDialogueData(
              [
                "Hola, sóc l'Urahara, i sigues benvingut a la tenda!",
                "Aquí podràs fer les diverses tirades al gacha.",
                "Tens prou diners per una tirada?",
                "Em vaig a fer una becadeta...",
              ],
              [
                'lib/images/urahara_character/urahara_1.png',
                'lib/images/urahara_character/urahara_2.png',
                'lib/images/urahara_character/urahara_3.png',
                'lib/images/urahara_character/urahara_4.png',
                'lib/images/urahara_character/urahara_5.png',
              ],
            );
          }
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
