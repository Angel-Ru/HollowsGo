import 'package:flutter/material.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/widgets/combat/ultimate_service.dart';

class CombatActionButtons extends StatelessWidget {
  final CombatProvider combatProvider;
  final String techniqueName;
  final int aliatDamage;
  final int enemicDamage;
  final VoidCallback onVictory;
  final VoidCallback onDefeat;

  const CombatActionButtons({
    required this.combatProvider,
    required this.techniqueName,
    required this.aliatDamage,
    required this.enemicDamage,
    required this.onVictory,
    required this.onDefeat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: combatProvider.isEnemyTurn ||
                      combatProvider.isAttackInProgress ||
                      combatProvider.enemicHealth <= 0
                  ? null
                  : () => combatProvider.performAttack(
                        aliatDamage,
                        enemicDamage,
                        onVictory,
                        onDefeat,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              child: Column(
                children: [
                  const Text("LLUITA", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      techniqueName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "(MAL: $aliatDamage)",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.auto_awesome, color: Colors.black),
                onPressed: combatProvider.isEnemyTurn ||
                        combatProvider.isAttackInProgress ||
                        combatProvider.enemicHealth <= 0
                    ? null
                    : () {
                        // Cambié la llamada a setEnemyHealth
                        UltimateService().executeShinjiUlti(
                          context,
                          (damage) {
                            combatProvider.setEnemyHealth(
                                combatProvider.enemicHealth - damage);
                          },
                        );
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
