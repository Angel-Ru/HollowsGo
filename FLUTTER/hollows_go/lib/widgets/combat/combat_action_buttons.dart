import 'package:flutter/material.dart';
import 'package:hollows_go/service/audioservice.dart';
import 'package:provider/provider.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/providers/habilitat_provider.dart';
import 'package:hollows_go/widgets/combat/ultimate_service.dart';

class CombatActionButtons extends StatefulWidget {
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
  State<CombatActionButtons> createState() => _CombatActionButtonsState();
}

class _CombatActionButtonsState extends State<CombatActionButtons> {
  bool _alreadyEnded = false;

  Future<void> _handleVictory() async {
    if (_alreadyEnded) return;
    _alreadyEnded = true;
    await AudioService.instance.fadeOut();
    widget.onVictory();
  }

  Future<void> _handleDefeat() async {
    if (_alreadyEnded) return;
    _alreadyEnded = true;
    await AudioService.instance.fadeOut();
    widget.onDefeat();
  }

  @override
  Widget build(BuildContext context) {
    final bool ultiUsed = widget.combatProvider.ultiUsed;

    final bool canAct = !widget.combatProvider.isEnemyTurn &&
        !widget.combatProvider.isAttackInProgress &&
        widget.combatProvider.enemicHealth > 0;

    final habilitat = Provider.of<HabilitatProvider>(context).habilitat;
    final bool hasUltimate = habilitat != null;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Botó LLUITA amb Tooltip
          Expanded(
            flex: 3,
            child: Tooltip(
              message: '${widget.techniqueName} - MAL: ${widget.aliatDamage}' +
                  (widget.combatProvider.bonusAllyDamage > 0
                      ? ' +${widget.combatProvider.bonusAllyDamage}'
                      : ''),
              preferBelow: false,
              waitDuration: const Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: canAct
                    ? () async {
                        await widget.combatProvider.performAttack(
                          widget.aliatDamage,
                          widget.enemicDamage,
                          widget.skinId,
                          _handleVictory,
                          _handleDefeat,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                child: const Text(
                  "LLUITA",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Botó ULTI amb Tooltip només si hi ha habilitat
          Expanded(
            flex: 1,
            child: hasUltimate
                ? Tooltip(
                    message: habilitat!.efecte,
                    waitDuration: const Duration(milliseconds: 500),
                    preferBelow: false,
                    child: _buildUltiButton(canAct, ultiUsed, hasUltimate),
                  )
                : _buildUltiButton(canAct, ultiUsed, hasUltimate),
          ),
        ],
      ),
    );
  }

  Widget _buildUltiButton(bool canAct, bool ultiUsed, bool hasUltimate) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: !hasUltimate
            ? Colors.blueGrey
            : ultiUsed
                ? Colors.grey
                : Colors.yellow,
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
        icon: Icon(
          hasUltimate ? Icons.auto_awesome : Icons.lock,
          color: ultiUsed || !hasUltimate ? Colors.black54 : Colors.white,
        ),
        onPressed: (!canAct || ultiUsed || !hasUltimate)
            ? null
            : () async {
                widget.combatProvider.setUltiUsed(true);

                await UltimateService().executeUltimateForSkin(
                  context: context,
                  onDamageApplied: (damageDealt) async {
                    final newHealth =
                        widget.combatProvider.enemicHealth - damageDealt;
                    widget.combatProvider.setEnemyHealth(newHealth);

                    if (newHealth <= 0) {
                      await widget.combatProvider.updateSkinVidaActual(
                        skinId: widget.skinId,
                        vidaActual: widget.combatProvider.aliatHealth,
                      );
                      await _handleVictory();
                    }
                  },
                  onEnemyDefeated: _handleVictory,
                );
              },
      ),
    );
  }
}
