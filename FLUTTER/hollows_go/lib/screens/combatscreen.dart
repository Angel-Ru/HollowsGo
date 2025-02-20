import 'package:flutter/material.dart';

class CombatScreen extends StatelessWidget {
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
          // Contenido de la pantalla
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Imagen del enemigo
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'lib/images/combat_proves/aizen_combat.png',
                    width: 150, // Ajusta el tamaño según sea necesario
                  ),
                ),
                Spacer(),
                // Imagen del aliado
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    'lib/images/combat_proves/bleach_combat.png',
                    width: 200, // Ajusta el tamaño según sea necesario
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
