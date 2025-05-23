import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollows_go/imports.dart';
import 'package:hollows_go/widgets/healthbarwidget.dart';
import 'package:provider/provider.dart';

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
        // Contenedor de la imagen con efectos
        Container(
          height: isEnemy ? 300 : 250,
          width: isEnemy ? 300 : 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Sombra difuminada (base para el efecto de vuelo)
              if (!isHit) ...[
                Positioned.fill(
                  child: Transform.scale(
                    scale: 1.05,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      color: Colors.black.withOpacity(0.2),
                      colorBlendMode: BlendMode.dstATop,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Transform.scale(
                    scale: 1.03,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      color: Colors.black.withOpacity(0.1),
                      colorBlendMode: BlendMode.dstATop,
                    ),
                  ),
                ),
              ],

              // Imagen principal con máscara de difuminado
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(150), // Borde circular suave
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isHit ? 0.5 : 1.0,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 1.5,
                      sigmaY: 1.5,
                      tileMode: TileMode.decal,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.network(
                        imageUrl,
                        height: isEnemy ? 290 : 240, // Reducción para el efecto
                        width: isEnemy ? 290 : 240,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Resto del widget (barra de vida y nombre)
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
}
