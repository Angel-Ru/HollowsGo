import 'package:flutter/material.dart';

class MidScreenTurnIndicator extends StatelessWidget {
  final bool isEnemyTurn;

  const MidScreenTurnIndicator({required this.isEnemyTurn, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Indicador de torn de l'enemic
        AnimatedOpacity(
          opacity: isEnemyTurn ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_upward, color: Colors.red, size: 24),
              const SizedBox(width: 8),
              Container(height: 8, width: 120, color: Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Indicador de torn de l'aliat
        AnimatedOpacity(
          opacity: isEnemyTurn ? 0.2 : 1.0,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(height: 8, width: 120, color: Colors.green),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_downward, color: Colors.green, size: 24),
            ],
          ),
        ),
      ],
    );
  }
}
