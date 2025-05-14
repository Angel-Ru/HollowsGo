// health_bar_widget.dart
import 'package:hollows_go/imports.dart';

class HealthBarWidget extends StatelessWidget {
  final double currentHealth;
  final int maxHealth;

  const HealthBarWidget({
    required this.currentHealth,
    required this.maxHealth,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthPercentage = currentHealth / maxHealth;
    final barColor = healthPercentage < 0.2
        ? Colors.red
        : (healthPercentage < 0.6 ? Colors.orange : Colors.green);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 24,
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
                height: 24,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Text(
          "${currentHealth.toInt()}/$maxHealth",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
