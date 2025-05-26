import 'package:flutter/material.dart';

class MidScreenTurnIndicator extends StatelessWidget {
  final bool isEnemyTurn;
  final bool isEnemyFrozen;

  const MidScreenTurnIndicator({
    required this.isEnemyTurn,
    required this.isEnemyFrozen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: isEnemyTurn ? 1.0 : 0.2,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_upward,
                color: isEnemyFrozen ? Colors.blue : Colors.red,
                size: 30,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          opacity: isEnemyTurn ? 0.2 : 1.0,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 8),
              const Icon(Icons.arrow_downward, color: Colors.green, size: 30),
            ],
          ),
        ),
      ],
    );
  }
}
