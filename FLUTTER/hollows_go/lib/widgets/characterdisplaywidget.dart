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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Contenedor con efecto de borde ultra-sutil
        Container(
          height: isEnemy ? 300 : 250,
          width: isEnemy ? 300 : 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen principal con doble capa para el efecto de borde
              _buildSoftEdgedImage(),

              // Sombra circular suave (opcional)
              if (!isHit)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Barra de vida y nombre (sin cambios)
        const SizedBox(height: 1),
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

  Widget _buildSoftEdgedImage() {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(150), // Ajusta según la forma del personaje
      child: Stack(
        children: [
          // Capa base con mini-difuminado (0.5px)
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 0.5,
              sigmaY: 0.5,
              tileMode: TileMode.decal,
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              color: Colors.black.withOpacity(0.05),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Capa superior nítida (recortada 1px más pequeña)
          Center(
            child: Container(
              margin: const EdgeInsets.all(1), // Compensa el blur
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isHit ? 0.5 : 1.0,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
