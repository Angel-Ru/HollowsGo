import 'package:flutter/material.dart';

class MidScreenTurnIndicator extends StatelessWidget {
  final bool isEnemyTurn;

  const MidScreenTurnIndicator({required this.isEnemyTurn});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Fletxa enemic (cap a esquerra)
          AnimatedOpacity(
            opacity: isEnemyTurn ? 1.0 : 0.3,
            duration: Duration(milliseconds: 300),
            child: Transform.rotate(
              angle: 3.14, // 180º per apuntar a la dreta
              child: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.redAccent,
              ),
            ),
          ),

          // Línia central estirada
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.redAccent,
                    Colors.white,
                    Colors.greenAccent,
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Fletxa aliat (cap a dreta)
          AnimatedOpacity(
            opacity: isEnemyTurn ? 0.3 : 1.0,
            duration: Duration(milliseconds: 300),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 28,
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
