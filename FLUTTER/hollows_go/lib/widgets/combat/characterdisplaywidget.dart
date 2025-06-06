import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hollows_go/imports.dart';
import 'package:hollows_go/widgets/combat/healthbarwidget.dart';
import 'package:provider/provider.dart';

class CharacterDisplayWidget extends StatefulWidget {
  final String imageUrl;
  final String name;
  final double health;
  final int maxHealth;
  final bool isHit;
  final bool isEnemy;

  final int buffAmount;
  final int debuffAmount;

  final double imageSize;
  final double blurSigma;

  final bool isBleeding;
  final bool isFrozen;
  final bool isImmune;

  final bool showInkEffect;

  // NOVES PROPIETATS per Senjumaru
  final bool showSenjumaruEffect;
  final int senjumaruAttackCount;

  const CharacterDisplayWidget({
    required this.imageUrl,
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.isHit,
    this.isEnemy = false,
    this.buffAmount = 0,
    this.debuffAmount = 0,
    this.imageSize = 100,
    this.blurSigma = 0.8,
    this.isBleeding = false,
    this.isFrozen = false,
    this.isImmune = false,
    this.showInkEffect = false,
    this.showSenjumaruEffect = false,
    this.senjumaruAttackCount = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<CharacterDisplayWidget> createState() => _CharacterDisplayWidgetState();
}

class _CharacterDisplayWidgetState extends State<CharacterDisplayWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void didUpdateWidget(CharacterDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showInkEffect && !oldWidget.showInkEffect) {
      _startInkAnimation();
    }
  }

  void _startInkAnimation() async {
    setState(() => _opacity = 1.0);
    await Future.delayed(const Duration(milliseconds: 250));
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _opacity = 0.0);
  }

  Widget buildStatusIcon() {
    if (widget.isEnemy && widget.debuffAmount > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_downward, color: Colors.red, size: 10),
          Text(
            '-${widget.debuffAmount}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      );
    } else if (!widget.isEnemy && widget.buffAmount > 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_upward, color: Colors.green, size: 10),
          Text(
            '+${widget.buffAmount}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = 1.9;
    final double containerSize = widget.imageSize * scaleFactor;
    final double blur =
        widget.isEnemy ? widget.blurSigma * 1.2 : widget.blurSigma;
    final BorderRadius imageBorderRadius = BorderRadius.circular(10);

    final combatProvider = Provider.of<CombatProvider>(context);
    final String displayName =
        widget.isEnemy ? combatProvider.enemyName : widget.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: containerSize,
          width: containerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scaleFactor,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: ClipRRect(
                    borderRadius: imageBorderRadius,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.network(
                        widget.imageUrl,
                        alignment: Alignment.center,
                        color: Colors.black.withOpacity(0.05),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: scaleFactor,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: widget.isHit ? 0.5 : 1.0,
                  child: ClipRRect(
                    borderRadius: imageBorderRadius,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.network(
                        widget.imageUrl,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.isEnemy) ...[
                // Efecte tinta Ichibe
                AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: Image.asset(
                    'assets/special_attack/ichibe/imatge_tinta.png',
                    fit: BoxFit.cover,
                    width: containerSize,
                    height: containerSize,
                  ),
                ),

                // Efecte tela Senjumaru (amb les dues teles apilades i fadeIn)
                if (widget.showSenjumaruEffect)
                  Stack(
                    children: [
                      AnimatedOpacity(
                        opacity: widget.senjumaruAttackCount == 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                        child: Image.asset(
                          'assets/special_attack/senjumaru/tela_1.png',
                          fit: BoxFit.cover,
                          width: containerSize,
                          height: containerSize,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: widget.senjumaruAttackCount == 1 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeIn,
                        child: Image.asset(
                          'assets/special_attack/senjumaru/tela_2.png',
                          fit: BoxFit.cover,
                          width: containerSize,
                          height: containerSize,
                        ),
                      ),
                    ],
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.isEnemy) ...[
                    if (widget.debuffAmount > 0) ...[
                      buildStatusIcon(),
                      const SizedBox(width: 6),
                    ],
                    if (widget.isBleeding)
                      Image.asset(
                        'assets/special_attack/unohana/icone_sang.png',
                        width: 18,
                        height: 18,
                      ),
                    if (widget.isFrozen)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'assets/special_attack/rukia/icone_gel.png',
                          width: 18,
                          height: 18,
                        ),
                      ),
                  ],
                  if (!widget.isEnemy) ...[
                    if (widget.isBleeding)
                      Image.asset(
                        'assets/special_attack/unohana/icone_sang.png',
                        width: 18,
                        height: 18,
                      ),
                    if (widget.isFrozen)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'assets/special_attack/rukia/icone_gel.png',
                          width: 18,
                          height: 18,
                        ),
                      ),
                    if (widget.isImmune)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Image.asset(
                          'assets/special_attack/yhwach/icone_escut.png',
                          width: 18,
                          height: 18,
                        ),
                      ),
                  ],
                  Expanded(
                    child: widget.isEnemy
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              HealthBarWidget(
                                currentHealth: widget.health,
                                maxHealth: widget.maxHealth,
                                showText: false,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${widget.health.toInt()}/${widget.maxHealth}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                "${widget.health.toInt()}/${widget.maxHealth}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              HealthBarWidget(
                                currentHealth: widget.health,
                                maxHealth: widget.maxHealth,
                                showText: false,
                              ),
                            ],
                          ),
                  ),
                  if (!widget.isEnemy && widget.buffAmount > 0) ...[
                    const SizedBox(width: 6),
                    buildStatusIcon(),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
