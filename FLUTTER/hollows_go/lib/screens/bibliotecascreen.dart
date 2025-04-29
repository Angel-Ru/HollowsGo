import 'dart:ui';

import '../imports.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  bool _switchValue = false;
  String _randomSkinName =
      ''; // Variable para almacenar el nombre de la skin aleatoria

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
    provider.fetchPersonatgesAmbSkins(userId.toString());
    provider.fetchPersonatgesEnemicsAmbSkins();
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

    // Actualizar el nombre de la skin seleccionada
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);
    final personatges =
        _switchValue ? provider.characterEnemies : provider.personatges;

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
                image: AssetImage(
                  _switchValue
                      ? 'lib/images/biblioteca_enemics_fondo.png'
                      : 'lib/images/biblioteca_aliats_fondo.png',
                ),
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DialogueWidget(
                      characterName: _switchValue ? 'Nel' : 'Mayuri Kurotsuchi',
                      nameColor: _switchValue ? Colors.green : Colors.purple,
                      bubbleColor: Color.fromARGB(212, 238, 238, 238),
                      backgroundColor: _switchValue
                          ? Color.fromARGB(255, 76, 175, 80)
                          : Color.fromARGB(255, 167, 55, 187),
                    ),
                  ),

                  // SWITCH
                  _buildModeSwitch(),

                  SizedBox(height: 10),

                  // Botón de selección aleatoria con nombre de skin
                  if (!_switchValue)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        // Centrar el botón horizontalmente
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

                  if (!_switchValue && provider.selectedSkinAliat != null)
                    SelectedSkinCard(skin: provider.selectedSkinAliat!),

                  // Lista de personajes
                  ...personatges
                      .map((personatge) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: PersonatgesCardSwiper(
                              personatge: personatge,
                              isEnemyMode: _switchValue,
                              onSkinSelected: _selectSkinAliat,
                              onSkinDeselected: () {
                                final provider = Provider.of<
                                        SkinsEnemicsPersonatgesProvider>(
                                    context,
                                    listen: false);
                                provider.unselectSkinAliat();
                                setState(() {
                                  _randomSkinName = ''; // Resetear el nombre
                                });
                              },
                              selectedSkin: provider.selectedSkinAliat,
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
        children: [
          Text(
            _switchValue ? 'Biblioteca Enemics' : 'Biblioteca Aliats',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Switch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
                _randomSkinName = ''; // Resetear el nombre al cambiar de modo
              });
              final dialogueProvider =
                  Provider.of<DialogueProvider>(context, listen: false);
              dialogueProvider.loadDialogueFromJson(value ? 'nel' : 'mayuri');
            },
            activeColor: Colors.yellowAccent,
            inactiveTrackColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
