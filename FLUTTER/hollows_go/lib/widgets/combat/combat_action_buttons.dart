import 'package:flutter/material.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/widgets/combat/ultimate_service.dart';

class CombatActionButtons extends StatelessWidget {
  final CombatProvider combatProvider;
  final String techniqueName;
  final int aliatDamage;
  final int enemicDamage;
  final int skinId;
  final VoidCallback onVictory;
  final VoidCallback onDefeat;

  const CombatActionButtons({
    required this.combatProvider,
    required this.techniqueName,
    required this.aliatDamage,
    required this.enemicDamage,
    required this.skinId,
    required this.onVictory,
    required this.onDefeat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool ultiUsed = combatProvider.ultiUsed;

    final bool canAct = !combatProvider.isEnemyTurn &&
        !combatProvider.isAttackInProgress &&
        combatProvider.enemicHealth > 0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Botó LLUITA
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: canAct
                  ? () => combatProvider.performAttack(
                        aliatDamage,
                        enemicDamage,
                        skinId,
                        onVictory,
                        onDefeat,
                      )
                  : null,
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
          // Botó ULTI
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: ultiUsed ? Colors.grey : Colors.yellow,
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
                icon: Icon(Icons.auto_awesome,
                    color: ultiUsed ? Colors.black54 : Colors.black),
                onPressed: (!canAct || ultiUsed)
                    ? null
                    : () async {
                        combatProvider.setUltiUsed(true);

                        await UltimateService().executeShinjiUlti(
                          context,
                          (damageDealt) async {
                            final newHealth = combatProvider.enemicHealth - damageDealt;
                            combatProvider.setEnemyHealth(newHealth);

                            if (newHealth <= 0) {
                              await combatProvider.updateSkinVidaActual(
                                skinId: skinId,
                                vidaActual: combatProvider.aliatHealth,
                              );
                              onVictory();
                            }
                          },
                          onVictory,
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
