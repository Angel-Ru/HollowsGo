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
        // Contenedor con efecto de bordes difuminados
        Container(
          height: isEnemy ? 300 : 250,
          width: isEnemy ? 300 : 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Imagen original
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isHit ? 0.5 : 1.0,
                child: _buildImageWithFeatheredEdges(),
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

  Widget _buildImageWithFeatheredEdges() {
    return ShaderMask(
      blendMode: BlendMode.dstOut,
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.center,
          radius: 0.9,
          colors: [
            Colors.black,
            Colors.transparent,
          ],
          stops: [0.8, 1.0],
        ).createShader(bounds);
      },
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.error),
      ),
    );
  }
}
