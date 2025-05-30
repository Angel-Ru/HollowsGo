import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hollows_go/screens/dialegnoticies.dart';
import 'package:hollows_go/widgets/novetatscontainerstate.dart';
import 'package:provider/provider.dart';

import 'package:hollows_go/imports.dart';
import 'package:hollows_go/service/audioservice.dart';
import '../widgets/missions/mission_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeScreenController _controller;
  String _imagePath = '';
  Timer? _timer;
  bool _mostrarDetallsSkin = false;

  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  late final UIProvider _uiProvider;
  late VoidCallback _uiListener;

  @override
  void initState() {
    super.initState();

    _controller = HomeScreenController(context);

    _expandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _expandAnimation =
        CurvedAnimation(parent: _expandController, curve: Curves.easeInOut);

    // Inicialitza el UIProvider i el listener per detectar canvis de menú
    _uiProvider = Provider.of<UIProvider>(context, listen: false);

    _uiListener = () {
      switch (_uiProvider.selectedMenuOpt) {
        case 0:
          AudioService.instance.playScreenMusic('home');
          break;
        case 1:
          AudioService.instance.playScreenMusic('mapa');
          break;
        case 2:
          AudioService.instance.playScreenMusic('tenda');
          break;
        case 3:
          AudioService.instance.playScreenMusic('biblioteca');
          break;
        case 4:
          AudioService.instance.playScreenMusic('perfil');
          break;
        default:
          AudioService.instance.stop();
      }
    };

    _uiProvider.addListener(_uiListener);

    // Reproduir la música inicial segons el menú per si no és home
    _uiListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final avatarUrl = await _controller.loadProfileImage();
        setState(() => _imagePath = avatarUrl);
      } catch (e) {
        print("Error al carregar avatar: $e");
      }

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUserPoints();
      _timer = Timer.periodic(
        Duration(seconds: 5),
        (_) => userProvider.fetchUserPoints(),
      );

      Provider.of<VialsProvider>(context, listen: false)
          .fetchVials(userProvider.userId);

      Provider.of<DialogueProvider>(context, listen: false)
          .loadDialogueFromJson("ichigo");

      await _controller.loadUserData();
      final selectedProvider =
          Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
      selectedProvider.getSkinSeleccionada(userProvider.userId);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    _expandController.dispose();

    _uiProvider.removeListener(_uiListener);

    super.dispose();
  }

  Skin? _getSkinSeleccionada(SkinsEnemicsPersonatgesProvider provider) {
    return provider.selectedSkinQuincy ??
        provider.selectedSkinAliat ??
        provider.selectedSkinEnemic;
  }

  Widget _getSelectedScreenWithKey(int index) {
    switch (index) {
      case 1:
        return KeyedSubtree(
          key: ValueKey('mapa'),
          child: Mapscreen(profileImagePath: _imagePath),
        );
      case 2:
        return KeyedSubtree(
          key: ValueKey('tenda'),
          child: TendaScreen(),
        );
      case 3:
        return KeyedSubtree(
          key: ValueKey('biblio'),
          child: BibliotecaScreen(),
        );
      case 4:
        return KeyedSubtree(
          key: ValueKey('perfil'),
          child: PerfilScreen(),
        );
      default:
        return SizedBox.shrink(key: ValueKey('empty'));
    }
  }

  void _toggleExpand() {
    setState(() {
      _mostrarDetallsSkin = !_mostrarDetallsSkin;
      if (_mostrarDetallsSkin) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

  void _showDialegNoticies() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: DialegNoticies(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final double topMargin =
        MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeAppBar(
        imagePath: _imagePath,
        actions: [
          IconButton(
            icon: Icon(Icons.menu_open),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
            tooltip: 'Mostrar missions diaries',
          )
        ],
      ),
      endDrawer: MissionsDrawer(usuariId: userProvider.userId),
      body: Stack(
        children: [
          HomeBackground(),
          Consumer<SkinsEnemicsPersonatgesProvider>(
            builder: (context, provider, _) {
              final skin = _getSkinSeleccionada(provider);
              if (skin == null) return SizedBox();

              return AnimatedAlign(
                alignment: _mostrarDetallsSkin
                    ? Alignment.center
                    : Alignment.topCenter,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: _mostrarDetallsSkin ? 0 : topMargin,
                    left: 16,
                    right: 16,
                  ),
                  child: ScaleTransition(
                    scale: _expandAnimation,
                    child: _buildExpandedCard(skin),
                  ),
                ),
              );
            },
          ),
          Consumer<SkinsEnemicsPersonatgesProvider>(
            builder: (context, provider, _) {
              final skin = _getSkinSeleccionada(provider);
              if (skin == null || _mostrarDetallsSkin) return SizedBox();

              return Positioned(
                top: topMargin,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: _toggleExpand,
                  child: _buildSmallCard(skin),
                ),
              );
            },
          ),
          if (!_mostrarDetallsSkin)
            Positioned(
              top: topMargin + 200, // Ajusta la posició segons necessiti
              left: 0,
              right: 0,
              child: NovetatsContainer(
                onTap: _showDialegNoticies,
              ),
            ),
          if (uiProvider.selectedMenuOpt == 0) DialogueSection(),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 600),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _getSelectedScreenWithKey(uiProvider.selectedMenuOpt),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CombatScreen()),
        ),
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

  Widget _buildSmallCard(Skin skin) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              skin.imatge ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              skin.nom,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _expandController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _expandController.value * 3.1416,
                child: child,
              );
            },
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              onPressed: _toggleExpand,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedCard(Skin skin) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  skin.imatge ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    skin.nom,
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          color: Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_up,
                      color: Colors.grey, size: 32),
                  onPressed: _toggleExpand,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _DetallsSkinCard(skin),
        ],
      ),
    );
  }

  Widget _DetallsSkinCard(Skin skin) {
    String getNomRaca(int? raca) {
      switch (raca) {
        case 0:
          return 'Quincy';
        case 1:
          return 'Shinigami';
        case 2:
          return 'Hollow / Enemic';
        default:
          return 'Desconegut';
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (skin.vidaMaxima != null && skin.currentHealth != null)
            Text(
              'Vida: ${skin.currentHealth} / ${skin.vidaMaxima}',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          if (skin.raca != null)
            Text(
              'Raça: ${getNomRaca(skin.raca)}',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          if (skin.malTotal != null)
            Text(
              'Mal: ${skin.malTotal}',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
        ],
      ),
    );
  }
}
