import 'package:flutter/material.dart';

class TurnIndicator extends StatelessWidget {
  final bool isEnemyTurn;
  final String allyName;
  final String enemyName;

  const TurnIndicator({
    required this.isEnemyTurn,
    required this.allyName,
    required this.enemyName,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isEnemyTurn
              ? Colors.red.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          isEnemyTurn ? " $enemyName" : "$allyName ",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
