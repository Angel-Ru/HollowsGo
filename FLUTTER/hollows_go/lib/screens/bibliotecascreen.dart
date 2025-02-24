import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hollows_go/imports.dart';
import 'package:hollows_go/models/skin.dart';
import 'package:hollows_go/providers/skins_enemics_personatges.dart';
import 'package:provider/provider.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  int _dialogIndex = 0;
  bool _switchValue = false; // Estat del switch

  final List<String> _dialoguesEnemigos = [
    "Oh, quina sorpresa.",
    "Un altre ignorant en busca de coneixement?",
    "Benvingut al meu arxiu de meravelles...",
    "O potser hauria de dir, al teu infern de curiositat?",
    "Espero que hagis vingut a aprendre, i no només a perdre el temps.",
    "T’agradaria ser el meu pròxim subjecte d’experimentació?",
    "Els meus arxius contenen el que cap altre Shinigami gosaria investigar.",
    "Mmm... potser aquesta és una oportunitat per fer un experiment amb tu...",
  ];

  final List<String> _dialoguesAliats = [
    "Hola, sóc la Nel.",
    "On es l'Ichigo, tinc por!",
    "El Pesche el Dondochakka i el Bawabawa son els germans de la Nel",
    "Per què tots aquí tenen una cara tan enfadada?",
    "Ai ai ai... la Nel no vol estar aquí...",
    "Aquest lloc fa molta por...",
    "Ichigo, vine a buscar la Nel, si us plau...",
  ];

  final List<String> _mayuriImages = List.generate(
      8, (index) => 'lib/images/mayuri_character/mayuri_${index + 1}.png');
  final List<String> _nelImages = List.generate(
      4, (index) => 'lib/images/nel_character/nel_${index + 1}.png');

  int _mayuriImageIndex = 0;
  int _nelImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carregar les dades de l'usuari
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId'); // Obtenir l'ID de l'usuari

    if (userId == null) {
      print("No s'ha trobat l'ID de l'usuari a SharedPreferences.");
      return;
    }

    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    provider.fetchPersonatgesAmbSkins(userId.toString()); // Carregar aliats
    provider.fetchPersonatgesEnemicsAmbSkins(); // Carregar enemics
  }

  void _selectSkinAliat(Skin skin) {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    provider.setSelectedSkinAliat(
        skin); // Guardem la skin seleccionada per a l'aliat
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);

    // Seleccionar la llista de personatges segons l'estat del Switch
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
          // Fons de pantalla
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
                  // Contenidor de personatge amb diàleg
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _dialogIndex = (_dialogIndex + 1) %
                                (_switchValue
                                    ? _dialoguesAliats.length
                                    : _dialoguesEnemigos.length);
                            if (_switchValue) {
                              _nelImageIndex =
                                  (_nelImageIndex + 1) % _nelImages.length;
                            } else {
                              _mayuriImageIndex = (_mayuriImageIndex + 1) %
                                  _mayuriImages.length;
                            }
                          });
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
                                _switchValue
                                    ? _nelImages[_nelImageIndex]
                                    : _mayuriImages[_mayuriImageIndex],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _dialogIndex = (_dialogIndex + 1) %
                                  (_switchValue
                                      ? _dialoguesAliats.length
                                      : _dialoguesEnemigos.length);
                              if (_switchValue) {
                                _nelImageIndex =
                                    (_nelImageIndex + 1) % _nelImages.length;
                              } else {
                                _mayuriImageIndex = (_mayuriImageIndex + 1) %
                                    _mayuriImages.length;
                              }
                            });
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
                                    _switchValue
                                        ? _dialoguesAliats[_dialogIndex]
                                        : _dialoguesEnemigos[_dialogIndex],
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
                              // Switch
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
                  // Personatges i Skins
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
                                      provider.selectedSkinAliat?.id == skin.id;

                                  return GestureDetector(
                                    onTap: () {
                                      if (!_switchValue) {
                                        _selectSkinAliat(
                                            skin); // Seleccionar skin per a l'aliat
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Column(
                                        children: [
                                          // Imatge de la skin amb marcador de selecció
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
                                          // Nom de la skin
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
                                          // Qualitat en estrelles (exemple)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              5, // Exemple: 5 estrelles màxim
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
