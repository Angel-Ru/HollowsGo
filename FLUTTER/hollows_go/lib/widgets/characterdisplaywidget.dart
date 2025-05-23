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

  final double imageSize;
  final double blurSigma;

  const CharacterDisplayWidget({
    required this.imageUrl,
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.isHit,
    this.isEnemy = false,
    this.imageSize = 100,
    this.blurSigma = 0.8,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double scaleFactor = 1.9; // Igual per enemic i aliat
    final double containerSize = imageSize * scaleFactor;
    final double blur = isEnemy ? blurSigma * 1.2 : blurSigma;
    final BorderRadius imageBorderRadius = BorderRadius.circular(10);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: containerSize,
          width: containerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fons desenfocat amb cantons rodons
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

              // Imatge nítida a sobre amb cantons rodons
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
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
                      showText: false, // No mostrar text dins la barra
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${health.toInt()}/$maxHealth", // Mostrar text separat
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isEnemy) ...[
                const SizedBox(width: 10),
                HealthBarWidget(
                  currentHealth: health,
                  maxHealth: maxHealth,
                  showText: false, // No mostrar text per enemic
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
