import 'package:hollows_go/imports.dart';
import 'package:hollows_go/screens/bibliotecascreen.dart';
import 'package:hollows_go/screens/mapscreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _imagePath =
      'lib/images/perfil_predeterminat/perfil_predeterminat.jpg'; // Imagen predeterminada
  final String _coinImagePath =
      'lib/images/kan_moneda.png'; // Ruta de la imagen de la moneda
  int _coinCount = 0; // Número de monedas
  String _username = 'Usuario'; // Nombre del usuario (valor por defecto)

  get imageperfil => _imagePath;

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
    _loadUserData(); // Cargar los datos del usuario desde SharedPreferences
    _currentImage = _ichigoImages[0]; // Inicializar _currentImage
    _previousImage = _currentImage;
  }

  // Método de logout que elimina todas las preferencias
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Limpiar todas las preferencias
    await prefs.clear();

    // Redirigir al PreHomeScreen o pantalla de inicio
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PreHomeScreen()),
    );
  }

  // Método para elegir una nueva imagen de perfil
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

  // Cargar la imagen de perfil desde las preferencias compartidas
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Si no hay imagen guardada, usamos la imagen predeterminada
      _imagePath = prefs.getString('profileImagePath') ??
          'lib/images/perfil_predeterminat/perfil_predeterminat.jpg';
    });
  }

  // Cargar los datos del usuario desde SharedPreferences (nombre y puntos)
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coinCount =
          prefs.getInt('userPunts') ?? 0; // Obtener los puntos almacenados
      _username = prefs.getString('userName') ??
          'Usuario'; // Obtener el nombre del usuario
    });
  }

  // Método para determinar qué pantalla mostrar según el índice seleccionado
  Widget _getSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Center();
      case 1:
        return Mapscreen(profileImagePath: _imagePath);
      case 2:
        return TendaScreen();
      case 3:
        return BibliotecaScreen();
      default:
        return Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(_coinImagePath),
                ),
                SizedBox(width: 8),
                Text('$_coinCount'), // Mostrar los puntos obtenidos
              ],
            ),
            Row(
              children: [
                Text(_username), // Mostrar el nombre del usuario
                SizedBox(width: 8),
                PopupMenuButton(
                  offset:
                      Offset(0, 50), // Ajusta la posición del menú desplegable
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
                        // FALTA IMPLEMENTAR CONFIGURACIÓ
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
        ),
      ),
      body: Stack(
        children: [
          // Imagen de fondo
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
          _getSelectedScreen(uiProvider.selectedMenuOpt),
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
        ],
      ),
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
}
