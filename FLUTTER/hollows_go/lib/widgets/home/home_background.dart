import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'lib/images/homescreen_images/background.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
