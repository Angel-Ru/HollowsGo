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

  /// Personalización
  final double imageSize;
  final double blurSigma;

  const CharacterDisplayWidget({
    required this.imageUrl,
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.isHit,
    this.isEnemy = false,
    this.imageSize = 250,
    this.blurSigma = 3.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = isEnemy ? imageSize * 1.2 : imageSize;
    final double blur = isEnemy ? blurSigma * 1.2 : blurSigma;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen desenfocada de fondo para fusión natural
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: blur,
                  sigmaY: blur,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: size * 1.1, // Levemente más grande para efecto "halo"
                  width: size * 1.1,
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.05),
                  colorBlendMode: BlendMode.darken,
                ),
              ),

              // Imagen principal nítida
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isHit ? 0.5 : 1.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: size,
                  width: size,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
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
              if (!isEnemy)
                HealthBarWidget(currentHealth: health, maxHealth: maxHealth),
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
                HealthBarWidget(currentHealth: health, maxHealth: maxHealth),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
