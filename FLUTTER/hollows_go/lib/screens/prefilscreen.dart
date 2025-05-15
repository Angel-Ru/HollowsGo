import '../imports.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _imagePath =
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254001/CONFIGURATIONSCREEN/PROFILE_IMAGES/xj2epvx8tylh5qea2yic.jpg';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    // Obtener providers
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);

    // Cargar todos los datos necesarios
    await Future.wait([
      userProvider.fetchFavoritePersonatgeSkin(), // <-- Añade esta línea
      perfilProvider.fetchPerfilData(userId),
      _loadAvatar(userId, perfilProvider),
    ]);
  }

  Future<void> _loadAvatar(int userId, PerfilProvider perfilProvider) async {
    try {
      final avatarUrl = await perfilProvider.obtenirAvatar(userId);
      if (mounted) {
        setState(() {
          _imagePath = avatarUrl;
        });
      }
    } catch (e) {
      print('Error obtenint avatar: $e');
    }
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

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ),
                iconSize: 36,
                onPressed: () => _navigateToSettings(context),
              ),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Fondo que cubre toda la pantalla
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/Hirako.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Filtro para mejorar legibilidad del contenido
            Container(
              color: Colors.black.withOpacity(0.3),
            ),

            // Contenido principal
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // Avatar con botón de edición
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(_imagePath),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => _pickImage(context),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[700],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Text(
                          userProvider.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TITOL USUARI',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // Edición de título de usuario
                              },
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Estadísticas
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Partides',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Personatges',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Columna izquierda: Partidas + Personatge favorit
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jugades',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70)),
                                    Text('${perfilProvider.partidesJugades}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    SizedBox(height: 8),
                                    Text('Guanyades',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70)),
                                    Text('${perfilProvider.partidesGuanyades}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    SizedBox(height: 12),
                                    Text(
                                      'Preferits',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    if (userProvider.personatgepreferitnom !=
                                        null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Personatge preferit',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70)),
                                          Text(
                                              userProvider
                                                      .personatgepreferitnom ??
                                                  'No seleccionat',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                  ],
                                ),
                              ),

                              // Columna derecha: Personatges + Skin preferida
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('En possessió',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70)),
                                    Text('${perfilProvider.nombrePersonatges}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    SizedBox(height: 8),
                                    Text('Skins',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70)),
                                    Text('${perfilProvider.nombreSkins}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    SizedBox(height: 45),
                                    if (userProvider.skinPreferidaimatge !=
                                        null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text('Skin preferida',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white70)),
                                          SizedBox(height: 6),
                                          Container(
                                            height: 130,
                                            width: 130,
                                            margin: EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: NetworkImage(userProvider
                                                    .skinPreferidaimatge!),
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
