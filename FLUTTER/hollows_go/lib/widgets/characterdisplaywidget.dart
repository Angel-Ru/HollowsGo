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

  const CharacterDisplayWidget({
    required this.imageUrl,
    required this.name,
    required this.health,
    required this.maxHealth,
    required this.isHit,
    this.isEnemy = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double size = isEnemy ? 300 : 250;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen con borde difuminado sutil
              _buildSoftEdgedImage(size),

              // Sombra exterior (flotante)
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

  Widget _buildSoftEdgedImage(double size) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Capa inferior con blur
          ClipOval(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 1.2,
                sigmaY: 1.2,
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Imagen nítida encima
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
