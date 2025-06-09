import 'dart:ui';

// Aquí importes els teus models i providers
import 'package:hollows_go/service/audioservice.dart';
import 'package:hollows_go/widgets/custom_loading_indicator.dart';

import '../imports.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  int _currentMode = 0; // 0: Aliats, 1: Quincy, 2: Enemics
  String _randomSkinName = '';
  late Future<void> _initLoadFuture;

  @override
  void initState() {
    super.initState();
    _initLoadFuture = _loadUserData();
    _loadInitialDialogue();
    AudioService.instance.playScreenMusic('biblioteca');
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (userId == null) {
      print("No s'ha trobat l'ID de l'usuari a SharedPreferences.");
      throw Exception('User ID no trobat');
    }

    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    await provider.fetchPersonatgesAmbSkins(userId.toString());
    await provider.fetchEnemicsAmbSkins(userId.toString());
    await provider.fetchPersonatgesAmbSkinsQuincys(userId.toString());
    await provider.getSkinSeleccionada(userId);
  }

  void _loadInitialDialogue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson(_getDialogueCharacter());
    });
  }

  Future<void> _selectRandomSkin() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    if (_currentMode == 0) {
      await provider.selectRandomUserSkinAliat();
      setState(() {
        _randomSkinName = provider.selectedSkinAliat?.nom ?? '';
      });
    } else if (_currentMode == 1) {
      await provider.selectRandomUserSkinQuincy();
      setState(() {
        _randomSkinName = provider.selectedSkinQuincy?.nom ?? '';
      });
    } else if (_currentMode == 2) {
      await provider.selectRandomUserSkinEnemic();
      setState(() {
        _randomSkinName = provider.selectedSkinEnemic?.nom ?? '';
      });
    }
  }

  String _getModeTitle() {
    switch (_currentMode) {
      case 0:
        return 'Biblioteca Aliats';
      case 1:
        return 'Biblioteca Quincy';
      case 2:
        return 'Biblioteca Enemics';
      default:
        return 'Biblioteca';
    }
  }

  String _getBackgroundImage() {
    switch (_currentMode) {
      case 0:
        return 'lib/images/bibliotecascreen_images/biblioteca_aliats_fondo.png';
      case 1:
        return 'lib/images/bibliotecascreen_images/biblioteca_quincy_fondo.png';
      case 2:
        return 'lib/images/bibliotecascreen_images/biblioteca_enemics_fondo.png';
      default:
        return 'lib/images/bibliotecascreen_images/biblioteca_aliats_fondo.png';
    }
  }

  String _getDialogueCharacter() {
    switch (_currentMode) {
      case 0:
        return 'Mayuri';
      case 1:
        return 'Ryuken';
      case 2:
        return 'Nel';
      default:
        return 'Mayuri';
    }
  }

  Color _getDialogueColor() {
    switch (_currentMode) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.tealAccent;
      default:
        return Colors.purple;
    }
  }

  List<Personatge> _getCurrentPersonatges() {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);
    switch (_currentMode) {
      case 0:
        return provider.personatges;
      case 1:
        return provider.quincys;
      case 2:
        return provider.characterEnemies;
      default:
        return provider.personatges;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initLoadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CustomLoadingIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                'Error carregant les dades.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return _buildBibliotecaContent(context);
      },
    );
  }

  Widget _buildBibliotecaContent(BuildContext context) {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);
    final currentPersonatges = _getCurrentPersonatges();

    Skin? selectedSkin;
    switch (_currentMode) {
      case 0:
        selectedSkin = provider.selectedSkinAliat;
        break;
      case 1:
        selectedSkin = provider.selectedSkinQuincy;
        break;
      case 2:
        selectedSkin = provider.selectedSkinEnemic;
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.5),
              elevation: 0,
              title: null,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_getBackgroundImage()),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido principal (scrollable)
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 100,
              bottom: 150,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildModeSwitch(),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _selectRandomSkin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: Text(
                          'Seleccionar Skin Aleatoria',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Mostrar la targeta de skin seleccionada només si hi ha una skin seleccionada
                  if (selectedSkin != null)
                    SelectedSkinCard(skin: selectedSkin),

                  // Llista de personatges amb el swiper
                  ...currentPersonatges.map((personatge) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: PersonatgesCardSwiper(
                        personatge: personatge,
                        onSkinSelected: (skin) async {
                          final provider =
                              Provider.of<SkinsEnemicsPersonatgesProvider>(
                                  context,
                                  listen: false);
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getInt('userId');

                          if (userId == null) {
                            print("No s'ha trobat l'ID de l'usuari.");
                            return;
                          }

                          await provider.actualitzarSkinSeleccionada(
                              userId, skin.id);

                          await provider
                              .fetchPersonatgesAmbSkins(userId.toString());
                          await provider
                              .fetchEnemicsAmbSkins(userId.toString());
                          await provider.fetchPersonatgesAmbSkinsQuincys(
                              userId.toString());

                          setState(() {
                            if (_currentMode == 0) {
                              provider.getSkinSeleccionada(userId);
                              _randomSkinName = skin.nom;
                            } else if (_currentMode == 1) {
                              provider.getSkinSeleccionada(userId);
                            } else if (_currentMode == 2) {
                              provider.getSkinSeleccionada(userId);
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Skin actualitzada correctament!')),
                          );
                        },
                        onSkinDeselected: () async {
                          final provider =
                              Provider.of<SkinsEnemicsPersonatgesProvider>(
                                  context,
                                  listen: false);
                          final prefs = await SharedPreferences.getInstance();
                          final userId = prefs.getInt('userId');

                          if (userId == null) {
                            print("No s'ha trobat l'ID de l'usuari.");
                            return;
                          }

                          await provider.llevarkinSeleccionada(userId);

                          await provider
                              .fetchPersonatgesAmbSkins(userId.toString());
                          await provider
                              .fetchEnemicsAmbSkins(userId.toString());
                          await provider.fetchPersonatgesAmbSkinsQuincys(
                              userId.toString());

                          setState(() {
                            if (_currentMode == 0) {
                              provider.llevarkinSeleccionada(userId);
                              _randomSkinName = '';
                            } else if (_currentMode == 1) {
                              provider.llevarkinSeleccionada(userId);
                            } else if (_currentMode == 2) {
                              provider.llevarkinSeleccionada(userId);
                            }
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Skin deseleccionada correctament!')),
                          );
                        },
                        selectedSkin: selectedSkin,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Diàleg al final
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DialogueWidget(
                characterName: _getDialogueCharacter(),
                nameColor: _getDialogueColor(),
                bubbleColor: Color.fromARGB(212, 238, 238, 238),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSwitch() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getModeTitle(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentMode =
                        (_currentMode - 1) < 0 ? 2 : _currentMode - 1;
                    _resetSelectedSkins();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentMode = (_currentMode + 1) % 3;
                    _resetSelectedSkins();
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetSelectedSkins() {
    _randomSkinName = '';
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    final dialogueProvider =
        Provider.of<DialogueProvider>(context, listen: false);
    dialogueProvider.loadDialogueFromJson(_getDialogueCharacter());
  }
}
