import 'package:flutter/material.dart';

class MidScreenTurnIndicator extends StatelessWidget {
  final bool isEnemyTurn;

  const MidScreenTurnIndicator({required this.isEnemyTurn, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Línea roja con flecha hacia arriba (enemigo)
        AnimatedOpacity(
          opacity: isEnemyTurn ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 400),
          child: Column(
            children: [
              const Icon(Icons.arrow_upward, color: Colors.red, size: 24),
              Container(height: 4, width: 150, color: Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Línea verde con flecha hacia abajo (aliado)
        AnimatedOpacity(
          opacity: isEnemyTurn ? 0.2 : 1.0,
          duration: const Duration(milliseconds: 400),
          child: Column(
            children: [
              Container(height: 4, width: 150, color: Colors.green),
              const Icon(Icons.arrow_downward, color: Colors.green, size: 24),
            ],
          ),
        ),
      ],
    );
  }
}
