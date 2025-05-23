import 'dart:ui'; // Para ImageFilter.blur
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
        // Contenedor de la imagen con bordes difuminados
        Container(
          height: isEnemy ? 300 : 250,
          width: isEnemy ? 300 : 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen principal
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isHit ? 0.5 : 1.0,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ),

              // Máscara de difuminado perimetral
              IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      30), // Ajusta para suavizar esquinas
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 6, // Intensidad del difuminado (4-8 es óptimo)
                      sigmaY: 6,
                      tileMode: TileMode.decal,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black12
                          ],
                          stops: [0.6, 0.8, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Barra de vida y nombre
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
