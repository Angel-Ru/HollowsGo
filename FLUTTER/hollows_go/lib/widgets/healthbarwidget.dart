import 'package:flutter/material.dart';

class HealthBarWidget extends StatelessWidget {
  final double currentHealth;
  final int maxHealth;
  final bool showText;
  final bool isVertical; // Nou paràmetre per orientació

  const HealthBarWidget({
    required this.currentHealth,
    required this.maxHealth,
    this.showText = true,
    this.isVertical = false, // per defecte horitzontal
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final healthPercentage = currentHealth / maxHealth;
    final barColor = healthPercentage < 0.2
        ? Colors.red
        : (healthPercentage < 0.6 ? Colors.orange : Colors.green);

    // Dimensions segons orientació
    final double width = isVertical ? 12 : 200;
    final double height = isVertical ? 160 : 12;

    return Stack(
      alignment: isVertical ? Alignment.bottomCenter : Alignment.centerLeft,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        Positioned(
          left: isVertical ? null : 0,
          bottom: isVertical ? 0 : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(
                begin: 0,
                end: isVertical ? height * healthPercentage : width * healthPercentage,
              ),
              builder: (context, value, child) {
                return Container(
                  width: isVertical ? width : value,
                  height: isVertical ? value : height,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            ),
          ),
        ),
        if (showText)
          Positioned.fill(
            child: Center(
              child: RotatedBox(
                quarterTurns: isVertical ? 1 : 0, // Rota el text si es vertical
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
          ),
      ],
    );
  }
}
