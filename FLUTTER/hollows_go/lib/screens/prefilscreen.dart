import '../imports.dart';
import '../widgets/perfil_avatar_widget.dart';
import '../widgets/perfil_header_widget.dart';
import '../widgets/perfil_stats_widget.dart';

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

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);

    userProvider.fetchFavoritePersonatgeSkin();
    perfilProvider.fetchPerfilData(userId);
    _loadAvatar(userId, perfilProvider);
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
      appBar: _buildAppBar(),
      body: _buildBody(userProvider, perfilProvider),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
                  SizedBox(height: 20),
                  PerfilAvatar(
                    imagePath: _imagePath,
                    onEditPressed: () => _pickImage(context),
                  ),
                  SizedBox(height: 20),
                  PerfilHeader(username: userProvider.username),
                  SizedBox(height: 40),
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
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/Hirako.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
