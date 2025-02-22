import 'dart:ui';

import 'package:flutter/material.dart';

class BibliotecaScreen extends StatefulWidget {
  @override
  _BibliotecaScreenState createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen> {
  int _dialogIndex = 0;
  bool _switchValue = false; // Estado del switch

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
    "Salutacions, amic.",
    "T'he estat esperant. Benvingut a la nostra biblioteca d'aliats.",
    "Aquí trobareu tot el coneixement necessari per a la nostra causa.",
    "Preparat per a l'aprenentatge i la col·laboració?",
    "Estem aquí per ajudar-nos mútuament a créixer.",
    "Tens alguna pregunta, company?",
    "El nostre arxiu és vast, però estic segur que trobaràs el que cerques.",
    "Junts, podem aconseguir tot el que desitgem.",
  ];

  final List<Map<String, dynamic>> _charactersEnemigos = [
    {
      "name": "Mayuri Kurotsuchi",
      "skins": [
        {
          "image": "lib/images/combat_proves/bleach_combat.png",
          "name": "Fase Final",
          "stars": 4
        },
        {
          "image": "lib/images/combat_proves/bleach_combat.png",
          "name": "Bankai",
          "stars": 3
        },
        {
          "image": "lib/images/combat_proves/bleach_combat.png",
          "name": "Hollow",
          "stars": 4
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> _charactersAliats = [
    {
      "name": "Urahara Kisuke",
      "skins": [
        {
          "image": "lib/images/combat_proves/bleach_combat.png",
          "name": "Shikai",
          "stars": 4
        },
        {
          "image": "lib/images/combat_proves/bleach_combat.png",
          "name": "Bankai",
          "stars": 5
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extiende el cuerpo detrás del AppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Altura del AppBar
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10), // Efecto de desenfoque
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white
                  .withOpacity(0.5), // Fondo blanco semi-transparente
              elevation: 0, // Sin sombra
              title: null, // No hay título en el AppBar
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Fondo de pantalla que cubre toda la pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _switchValue
                      ? 'lib/images/biblioteca_enemics_fondo.png' // Fondo aliados
                      : 'lib/images/biblioteca_aliats_fondo.png', // Fondo enemigos
                ),
                fit: BoxFit
                    .cover, // Asegura que la imagen cubra toda la pantalla
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  // Contenedor de personaje con diálogo
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
                          });
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _switchValue
                                ? Colors.green // Color verde para aliados
                                : Color.fromARGB(
                                    255, 167, 55, 187), // Morado para enemigos
                            image: DecorationImage(
                              image: AssetImage(
                                _switchValue
                                    ? 'lib/images/nel_character/nel_1.png' // Urahara para aliados
                                    : 'lib/images/mayuri_character/mayuri_1.png', // Mayuri para enemigos
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
                                  _switchValue
                                      ? 'Nelliel Tu Odelschwanck' // Nombre de personaje para aliados
                                      : 'Mayuri Kurotsuchi', // Nombre de personaje para enemigos
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellowAccent,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              // Eliminar el SizedBox aquí para pegar el nombre al diálogo
                              Container(
                                width: double.infinity,
                                height: 100, // Establecer altura fija
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _switchValue
                                      ? Colors.green
                                      : const Color.fromARGB(255, 167, 55, 187),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Text(
                                    _switchValue
                                        ? _dialoguesAliats[
                                            _dialogIndex] // Diálogo para aliados
                                        : _dialoguesEnemigos[
                                            _dialogIndex], // Diálogo para enemigos
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
                              // Switch debajo del avatar
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
                                          ? 'Biblioteca Aliats'
                                          : 'Biblioteca Enemics',
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
                                      activeColor: Colors.grey,
                                      inactiveTrackColor: Colors.yellowAccent,
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
                  // Personajes y Skins
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        (_switchValue ? _charactersAliats : _charactersEnemigos)
                            .map((character) {
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
                                character["name"],
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
                                itemCount: character["skins"].length,
                                controller:
                                    PageController(viewportFraction: 0.7),
                                itemBuilder: (context, index) {
                                  var skin = character["skins"][index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Column(
                                      children: [
                                        // Imagen de la skin
                                        Container(
                                          width: 180,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black, width: 2),
                                          ),
                                          child: ClipRRect(
                                            child: Image.asset(
                                              skin["image"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // Nombre de la skin
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            skin["name"],
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        // Calidad en estrellas
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            skin["stars"],
                                            (index) => Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
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
