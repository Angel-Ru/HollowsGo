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
      top: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isEnemyTurn ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Torn: ${isEnemyTurn ? enemyName : allyName}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
