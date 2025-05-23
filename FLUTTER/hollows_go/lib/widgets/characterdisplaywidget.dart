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

  /// Parámetros nuevos
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
    this.blurSigma = 1.2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escalamos automáticamente si es enemigo
    final double size = isEnemy ? imageSize * 1.2 : imageSize;
    final double blur = isEnemy ? blurSigma * 1.3 : blurSigma;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen con borde difuminado sutil
              _buildSoftEdgedImage(size, blur),

              // Sombra exterior flotante (opcional)
              if (!isHit)
                Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
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

  Widget _buildSoftEdgedImage(double size, double blur) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Capa inferior con blur suave
          ClipOval(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blur,
                sigmaY: blur,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Capa nítida encima
          ClipOval(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isHit ? 0.5 : 1.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
