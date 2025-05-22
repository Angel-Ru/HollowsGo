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
        // Imagen del personaje
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isHit ? 0.5 : 1.0,
          child: Image.network(
            imageUrl,
            height: isEnemy ? 300 : 250,
            width: isEnemy ? 300 : 250,
            errorBuilder: (_, __, ___) => const Icon(Icons.error),
          ),
        ),

        const SizedBox(height: 1),

        // Barra de vida y nombre (VERSIÓN CORREGIDA)
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ), // ¡Coma añadida aquí!
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
