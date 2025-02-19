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
  final int _coinCount = 0; // Número de monedas

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PreHomeScreen()),
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
        // Actualiza la imagen de perfil
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', _imagePath);
      }
    });
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
      case 0:
        return Center(child: Text('Welcome to the Home Screen!'));
      case 1:
        return Mapscreen();
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
                Text('$_coinCount'),
              ],
            ),
            Row(
              children: [
                Text('Perfil'),
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
