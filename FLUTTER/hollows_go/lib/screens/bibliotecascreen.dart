import 'dart:ui';
import '../imports.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Cargar diálogos iniciales para biblioteca
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('mayuri');
    });
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

  void _selectSkinAliat(Skin skin) {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    provider.setSelectedSkinAliat(skin);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);
    final dialogueProvider = Provider.of<DialogueProvider>(context);
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          dialogueProvider.nextDialogue();
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _switchValue
                                ? Colors.green
                                : Color.fromARGB(255, 167, 55, 187),
                            image: DecorationImage(
                              image: AssetImage(
                                  dialogueProvider.currentImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            dialogueProvider.nextDialogue();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(243, 194, 194, 194),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  _switchValue ? 'Nel' : 'Mayuri Kurotsuchi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellowAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 100,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _switchValue
                                      ? Colors.green
                                      : const Color.fromARGB(255, 167, 55, 187),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    dialogueProvider.currentDialogue,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      _switchValue
                                          ? 'Biblioteca Enemics'
                                          : 'Biblioteca Aliats',
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
                                        });

                                        final dialogueProvider =
                                            Provider.of<DialogueProvider>(
                                                context,
                                                listen: false);
                                        dialogueProvider.loadDialogueFromJson(
                                          value ? 'nel' : 'mayuri',
                                        
                                        );
                                      },
                                      activeColor: Colors.yellowAccent,
                                      inactiveTrackColor: Colors.grey,
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
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: personatges.map((personatge) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                personatge.nom,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: 250,
                              child: PageView.builder(
                                itemCount: personatge.skins.length,
                                controller:
                                    PageController(viewportFraction: 0.7),
                                itemBuilder: (context, index) {
                                  var skin = personatge.skins[index];
                                  final isSelected =
                                      provider.selectedSkinAliat?.id ==
                                          skin.id;
                                  return GestureDetector(
                                    onTap: () {
                                      if (!_switchValue) {
                                        _selectSkinAliat(skin);
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: 180,
                                                height: 180,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.green
                                                        : Colors.black,
                                                    width: isSelected ? 4 : 2,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  child: Image.network(
                                                    skin.imatge ?? '',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 24,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${skin.nom} (Mal: ${skin.malTotal})',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              5,
                                              (index) => Icon(
                                                Icons.star,
                                                color: index <
                                                        (skin.categoria ?? 0)
                                                    ? Colors.yellow
                                                    : Colors.grey,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
