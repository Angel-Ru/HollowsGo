import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hollows_go/imports.dart';
import 'package:hollows_go/widgets/healthbarwidget.dart';

class CharacterDisplayWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double health;
  final int maxHealth;
  final bool isHit;
  final bool isEnemy;

  final int buffAmount; // nous paràmetres d'estat
  final int debuffAmount;

  final double imageSize;
  final double blurSigma;

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = 1.9;
    final double containerSize = imageSize * scaleFactor;
    final double blur = isEnemy ? blurSigma * 1.2 : blurSigma;
    final BorderRadius imageBorderRadius = BorderRadius.circular(10);

    Widget buildStatusIcon() {
      if (buffAmount > 0) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.green, size: 18),
            Text(
              '+$buffAmount',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        );
      } else if (debuffAmount > 0) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_downward, color: Colors.red, size: 18),
            Text(
              '-$debuffAmount',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Espai per als estats a sobre
        SizedBox(
          height: 24,
          child: Center(child: buildStatusIcon()),
        ),

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
                        imageUrl,
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
                  opacity: isHit ? 0.5 : 1.0,
                  child: ClipRRect(
                    borderRadius: imageBorderRadius,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.network(
                        imageUrl,
                        alignment: Alignment.center,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Barra de vida i després nom en columna vertical
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: isEnemy
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!isEnemy) ...[
                    Row(
                      children: [
                        HealthBarWidget(
                          currentHealth: health,
                          maxHealth: maxHealth,
                          showText: false,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${health.toInt()}/$maxHealth",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (isEnemy) ...[
                    HealthBarWidget(
                      currentHealth: health,
                      maxHealth: maxHealth,
                      showText: false,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                name,
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
