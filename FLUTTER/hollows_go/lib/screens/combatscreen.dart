import 'package:flutter/material.dart';

class CombatScreen extends StatefulWidget {
  @override
  _CombatScreenState createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  double ichigoHealth = 1.0; // Salud actual de Ichigo (valor entre 0 y 1)
  double aizenHealth = 1.0; // Salud actual de Aizen (valor entre 0 y 1)

  // Vida máxima de los personajes (no cambia)
  int ichigoHP = 1000; // Vida máxima de Ichigo
  int aizenHP = 1000; // Vida máxima de Aizen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'lib/images/tenda_urahara.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Parte superior: Imagen de Aizen y su barra de salud
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centrar los elementos
                  children: [
                    // Imagen de Aizen, en la parte superior derecha
                    Image.asset(
                      'lib/images/combat_proves/aizen_combat.png',
                      height: 300, // Imagen más grande del enemigo
                      width: 300,
                    ),
                    SizedBox(height: 8),
                    // Contenedor para la barra de vida de Aizen y su nombre
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300, // Gris claro
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .end, // Alineamos todo a la derecha
                        children: [
                          // Nombre de Aizen (A la izquierda)
                          Flexible(
                            child: Text(
                              "Dondodochakka",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(
                              width:
                                  10), // Espacio entre el nombre y la barra de vida
                          // Barra de vida de Aizen (Se acorta hacia la derecha)
                          _buildHealthBar(aizenHealth, aizenHP),
                        ],
                      ),
                    ),
                  ],
                ),

                // Espacio entre las secciones
                Spacer(),

                // Parte inferior: Imagen de Ichigo y su barra de salud
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Centrar los elementos
                  children: [
                    // Imagen de Ichigo, en la parte inferior izquierda
                    Image.asset(
                      'lib/images/combat_proves/bleach_combat.png',
                      height: 250, // Imagen más grande del aliado
                      width: 250,
                    ),
                    SizedBox(height: 8),
                    // Contenedor gris para la barra de vida de Ichigo y su nombre + botón
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300, // Gris claro
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Barra de vida de Ichigo (Se acorta hacia la izquierda)
                              _buildHealthBar(ichigoHealth, ichigoHP),
                              SizedBox(
                                  width:
                                      10), // Espacio entre la barra de vida y el nombre
                              Flexible(
                                child: Text(
                                  "Ichigo",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          // Botón de "Luchar" debajo de la barra de vida de Ichigo
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Solo Reducir vida de Aizen, sin modificar la vida de Ichigo
                                if (aizenHealth > 0) {
                                  // Restamos 100 puntos de vida de Aizen, sin dividir entre la vida máxima
                                  aizenHealth -= 100 /
                                      aizenHP; // Convertimos los 100 puntos a porcentaje.
                                  if (aizenHealth < 0) {
                                    aizenHealth =
                                        0; // Aseguramos que no baje de 0
                                  }
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              textStyle: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            child: Text("LUCHAR"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Barra de salud con animación y colores según la salud
  Widget _buildHealthBar(double health, int hp) {
    // Determinamos el color de la barra de vida
    Color barColor = Colors.green;
    if (health < 0.6) {
      barColor = Colors.orange;
    }
    if (health < 0.2) {
      barColor = Colors.red;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Fondo de la barra de salud
        Positioned(
          child: Container(
            width: 200, // Acortamos la barra a 200
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        // Barra de salud con animación
        Positioned(
          left: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: health),
              duration: Duration(milliseconds: 500),
              builder: (context, value, child) {
                return Container(
                  width: 200 * value, // Acortamos la barra a 200
                  height: 24,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ),

        // Borde negro encima de la barra
        Positioned(
          child: Container(
            width: 200, // Acortamos la barra a 200
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),

        // Número de salud
        Positioned(
          child: Text(
            "${(health * hp).toInt()}/$hp", // Mostrar la vida actual sobre la máxima
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Colors.black,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
