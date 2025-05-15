import 'package:hollows_go/imports.dart';
import 'package:hollows_go/screens/prefilscreen.dart';
import 'package:hollows_go/widgets/home/dialogue_section.dart';
import 'package:hollows_go/widgets/home/home_app_bar.dart';
import 'package:hollows_go/widgets/home/home_background.dart';
import 'package:hollows_go/widgets/home/home_screen_controller.dart';




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenController _controller;
  String _imagePath = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = HomeScreenController(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final avatarUrl = await _controller.loadProfileImage();
        setState(() => _imagePath = avatarUrl);
      } catch (e) {
        print("Error al carregar avatar: $e");
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserPoints();
      _timer = Timer.periodic(Duration(seconds: 5), (_) => userProvider.fetchUserPoints());

      Provider.of<DialogueProvider>(context, listen: false).loadDialogueFromJson("ichigo");
      await _controller.loadUserData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 1: return Mapscreen(profileImagePath: _imagePath);
      case 2: return TendaScreen();
      case 3: return BibliotecaScreen();
      case 4: return PerfilScreen();
      default: return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(imagePath: _imagePath),
      body: Stack(
        children: [
          HomeBackground(),
          if (uiProvider.selectedMenuOpt == 0) DialogueSection(),
          _getSelectedScreen(uiProvider.selectedMenuOpt),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CombatScreen())),
        backgroundColor: Colors.red,
        child: Icon(Icons.sports_martial_arts),
        tooltip: 'Anar a CombatScreen (proves)',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: uiProvider.selectedMenuOpt,
        onTap: (i) => uiProvider.selectedMenuOpt = i,
      ),
    );
  }
}
