// health_bar_widget.dart
import 'package:hollows_go/imports.dart';

class HealthBarWidget extends StatelessWidget {
  final double currentHealth;
  final int maxHealth;
  final bool showText; // 👈 Nou paràmetre

  const HealthBarWidget({
    required this.currentHealth,
    required this.maxHealth,
    this.showText = true, // 👈 Per defecte sí que es mostra
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthPercentage = currentHealth / maxHealth;
    final barColor = healthPercentage < 0.2
        ? Colors.red
        : (healthPercentage < 0.6 ? Colors.orange : Colors.green);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          width: 200,
          height: 12, // 👈 Més estret
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        Positioned(
          left: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300),
              tween: Tween<double>(
                begin: 0,
                end: 200 * healthPercentage,
              ),
              builder: (context, value, child) => Container(
                width: value,
                height: 12, // 👈 Igual d’estret
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        if (showText)
          Positioned.fill(
            child: Center(
              child: Text(
                "${currentHealth.toInt()}/$maxHealth",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
