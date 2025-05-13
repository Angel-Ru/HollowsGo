import 'package:flutter/material.dart';

class CombatBackground extends StatelessWidget {
  final String image;

  const CombatBackground(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
