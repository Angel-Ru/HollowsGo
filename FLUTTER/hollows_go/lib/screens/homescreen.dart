import 'dart:ui';
import 'package:hollows_go/screens/prefilscreen.dart';
import '../imports.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // CHARACTER IMAGES AND DIALOGUES
  String _imagePath =
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254001/CONFIGURATIONSCREEN/PROFILE_IMAGES/xj2epvx8tylh5qea2yic.jpg';
  final String _coinImagePath =
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png';

  Timer? _timer;

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

      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson("ichigo");
    });
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      print("No s'ha trobat l'ID de l'usuari a SharedPreferences.");
      return;
    }

    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    await provider.fetchPersonatgesAmbSkins(userId.toString());
    precargarImagenes(provider.personatges);

    await provider.fetchEnemicsAmbSkins(userId.toString());
    precargarImagenes(provider.characterEnemies);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // USER PERFIL IMAGE
  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');

    setState(() {
      _imagePath = (imagePath != null && imagePath.isNotEmpty)
          ? imagePath
          : 'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254001/CONFIGURATIONSCREEN/PROFILE_IMAGES/xj2epvx8tylh5qea2yic.jpg';
    });
  }

  void precargarImagenes(List<Personatge> personatges) {
    for (var personatge in personatges) {
      for (var skin in personatge.skins) {
        final imageUrl = skin.imatge;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          CachedNetworkImageProvider(imageUrl).resolve(ImageConfiguration());
        }
      }
    }
  }

  // INFERIOR NAVIGATION BAR
  Widget _getSelectedScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return Mapscreen(profileImagePath: _imagePath);
      case 2:
        return TendaScreen();
      case 3:
        return BibliotecaScreen();
      case 4:
        return PerfilScreen();
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
              backgroundColor: const Color.fromARGB(255, 61, 61, 61),
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
                            backgroundImage: NetworkImage(_coinImagePath),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${userProvider.coinCount}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(userProvider.username,
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                              )),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              uiProvider.selectedMenuOpt =
                                  4; // Navega al perfil
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(_imagePath),
                            ),
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
              'lib/images/homescreen_images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 250),
                Image.network(
                  "https://res.cloudinary.com/dkcgsfcky/image/upload/v1744708246/PREHOMESCREEN/ee9hwiaahvn6mj2dcnov.png",
                  width: 300,
                ),
              ],
            ),
          ),
          if (uiProvider.selectedMenuOpt == 0)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 20),
                  DialogueWidget(
                    characterName: 'Ichigo Kurosaki',
                    nameColor: Colors.orange,
                    bubbleColor: Color.fromARGB(212, 238, 238, 238),
                  ),
                ],
              ),
            ),
          _getSelectedScreen(uiProvider.selectedMenuOpt),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CombatScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.sports_martial_arts, color: Colors.white),
        tooltip: 'Anar a CombatScreen (proves)',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: uiProvider.selectedMenuOpt,
        onTap: (index) {
          uiProvider.selectedMenuOpt = index;
        },
      ),
    );
  }

  // PICK IMAGE METHOD
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
}
