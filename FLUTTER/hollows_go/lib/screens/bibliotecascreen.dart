import 'dart:ui';
import 'package:http/http.dart' as http;
import '../imports.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  int _currentMode = 0; // 0: Aliados, 1: Quincy, 2: Enemigos
  String _randomSkinName = '';
  List<Personatge> _quincyPersonatges = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadInitialDialogue();
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
    await provider.fetchPersonatgesEnemicsAmbSkins();
    await _loadQuincyPersonatges(userId.toString());
  }

  Future<void> _loadQuincyPersonatges(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/user/quincy/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _quincyPersonatges =
              data.map((item) => Personatge.fromJson(item)).toList();
        });
      }
    } catch (error) {
      print('Error cargando personajes Quincy: $error');
    }
  }

  void _loadInitialDialogue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('mayuri');
    });
  }

  Future<void> _selectRandomSkin() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    await provider.selectRandomUserSkin();

    setState(() {
      _randomSkinName = provider.selectedSkinAliat?.nom ?? '';
    });
  }

  void _selectSkinAliat(Skin skin) {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    provider.setSelectedSkinAliat(skin);
    setState(() {
      _randomSkinName = skin.nom;
    });
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
        return 'mayuri';
      case 1:
        return 'ryuken';
      case 2:
        return 'nel';
      default:
        return 'mayuri';
    }
  }

  Color _getDialogueColor() {
    switch (_currentMode) {
      case 0:
        return Colors.purple;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
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
        return _quincyPersonatges;
      case 2:
        return provider.characterEnemies;
      default:
        return provider.personatges;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPersonatges = _getCurrentPersonatges();

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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 100),

                  // Diálogo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: DialogueWidget(
                      characterName: _getDialogueCharacter(),
                      nameColor: _getDialogueColor(),
                      bubbleColor: Color.fromARGB(212, 238, 238, 238),
                    ),
                  ),

                  // Triple Switch
                  _buildModeSwitch(),

                  SizedBox(height: 10),

                  // Botón de selección aleatoria (solo para aliados)
                  if (_currentMode == 0)
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
                            _randomSkinName.isEmpty
                                ? 'Seleccionar Skin Aleatoria'
                                : 'Skin seleccionada: $_randomSkinName',
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

                  // Skin seleccionada (solo para aliados)
                  if (_currentMode == 0 &&
                      Provider.of<SkinsEnemicsPersonatgesProvider>(context)
                              .selectedSkinAliat !=
                          null)
                    SelectedSkinCard(
                        skin: Provider.of<SkinsEnemicsPersonatgesProvider>(
                                context)
                            .selectedSkinAliat!),

                  // Lista de personajes
                  ...currentPersonatges
                      .map((personatge) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PersonatgesCardSwiper(
                              personatge: personatge,
                              isEnemyMode: _currentMode == 2,
                              onSkinSelected: _selectSkinAliat,
                              onSkinDeselected: () {
                                final provider = Provider.of<
                                        SkinsEnemicsPersonatgesProvider>(
                                    context,
                                    listen: false);
                                provider.unselectSkinAliat();
                                setState(() {
                                  _randomSkinName = '';
                                });
                              },
                              selectedSkin: _currentMode == 0
                                  ? Provider.of<
                                              SkinsEnemicsPersonatgesProvider>(
                                          context)
                                      .selectedSkinAliat
                                  : null,
                            ),
                          ))
                      .toList(),
                ],
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
                    _currentMode = (_currentMode - 1) % 3;
                    if (_currentMode < 0) _currentMode = 2;
                    _randomSkinName = '';
                  });
                  final dialogueProvider =
                      Provider.of<DialogueProvider>(context, listen: false);
                  dialogueProvider
                      .loadDialogueFromJson(_getDialogueCharacter());
                },
              ),
              Text(
                ['Aliats', 'Quincy', 'Enemics'][_currentMode],
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentMode = (_currentMode + 1) % 3;
                    _randomSkinName = '';
                  });
                  final dialogueProvider =
                      Provider.of<DialogueProvider>(context, listen: false);
                  dialogueProvider
                      .loadDialogueFromJson(_getDialogueCharacter());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
