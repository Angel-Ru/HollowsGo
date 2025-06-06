import 'package:hollows_go/screens/amistatsscreen.dart';
import '../imports.dart';
import 'package:hollows_go/service/audioservice.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _imagePath =
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254001/CONFIGURATIONSCREEN/PROFILE_IMAGES/xj2epvx8tylh5qea2yic.jpg';
  int _nivell = 1;
  int _expEmmagatzemada = 0;
  int _expMaxima = 100;

  @override
  void initState() {
    super.initState();
    _initializeData();
    AudioService.instance.playScreenMusic('perfil');
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);

    userProvider.fetchFavoritePersonatgeSkin();
    perfilProvider.fetchPerfilData(userId);
    _loadAvatar(userId, perfilProvider);
    _loadUserLevel(userId, perfilProvider);
    perfilProvider.carregarTitolUsuari(userId);
  }

  Future<void> _loadUserLevel(int userId, PerfilProvider perfilProvider) async {
    try {
      final expData = await perfilProvider.getexpuser(userId);
      if (mounted) {
        setState(() {
          _nivell = expData['nivell'] ?? 1;
          _expEmmagatzemada = expData['exp_emmagatzemada'] ?? 0;
          _expMaxima = expData['exp_max'] ?? 200;
        });
      }
    } catch (e) {
      print('Error obteniendo nivel del usuario: $e');
    }
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
    await Navigator.of(context)
        .push<String>(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => ImageSelectionPage(
          onImageSelected: (String imagePath) {
            setState(() {
              _imagePath = imagePath;
            });
            Navigator.of(context).pop(imagePath);
          },
        ),
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: Offset(0.05, 0),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
      ),
    )
        .then((imagePath) async {
      if (imagePath != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', _imagePath);
      }
    });
  }

  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          final slide = Tween<Offset>(
            begin: Offset(0.05, 0),
            end: Offset.zero,
          ).animate(animation);

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: slide,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final perfilProvider = Provider.of<PerfilProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _buildBody(userProvider, perfilProvider),
    );
  }

  Widget _buildBody(UserProvider userProvider, PerfilProvider perfilProvider) {
    return SizedBox.expand(
      child: Stack(
        children: [
          _buildBackground(),
          Container(color: Colors.black.withOpacity(0.3)),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  PerfilAvatar(
                    imagePath: _imagePath,
                    nivell: _nivell,
                    expEmmagatzemada: _expEmmagatzemada,
                    expMaxima: _expMaxima,
                  ),
                  const SizedBox(height: 20),
                  PerfilHeader(
                    username: userProvider.username,
                    userId: userProvider.userId,
                  ),
                  const SizedBox(height: 30),
                  PerfilStats(
                    partidesJugades: perfilProvider.partidesJugades,
                    partidesGuanyades: perfilProvider.partidesGuanyades,
                    nombrePersonatges: perfilProvider.nombrePersonatges,
                    nombreSkins: perfilProvider.nombreSkins,
                    personatgePreferitNom: userProvider.personatgepreferitnom,
                    skinPreferidaImatge: userProvider.skinPreferidaimatge,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 115,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _navigateWithFade(context, SettingsScreen()),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.settings,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _pickImage(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 205,
            right: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _navigateWithFade(context, AmistatsScreen()),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/Hirako.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
