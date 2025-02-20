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

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserData(); // Cargar los datos del usuario desde SharedPreferences
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
        return Center(child: Text('Welcome to the Home Screen!'));
      case 1:
      // return Mapscreen(profileImagePath: _imagePath);
      case 2:
        return TendaScreen();
      case 3:
        return BibliotecaScreen();
      default:
        return Center(child: Text('Welcome to the Home Screen!'));
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
}
