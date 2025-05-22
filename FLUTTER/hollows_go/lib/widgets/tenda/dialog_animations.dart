import 'package:flutter/material.dart';

class DialogAnimationManager {
  final TickerProvider vsync;

  // Controllers
  late final AnimationController fadeController;
  late final AnimationController scaleController;
  late final AnimationController fadeOutStarsController;
  late final AnimationController flashController;
  late final AnimationController fadeInImageController;

  // Animations
  late final Animation<double> fadeAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> fadeOutStarsAnimation;
  late final Animation<double> flashAnimation;
  late final Animation<double> fadeInImageAnimation;

  DialogAnimationManager({required this.vsync}) {
    fadeController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    scaleController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    fadeOutStarsController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 800),
    );

    flashController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    fadeInImageController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeIn,
    );

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: scaleController,
        curve: Curves.elasticOut,
      ),
    );

    fadeOutStarsAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: fadeOutStarsController,
        curve: Curves.easeOut,
      ),
    );

    flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: flashController,
        curve: Curves.easeInOut,
      ),
    );

    fadeInImageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: fadeInImageController,
        curve: Curves.easeIn,
      ),
    );
  }

  void playEntryAnimation() {
    fadeController.forward();
    scaleController.forward();
  }

  void dispose() {
    fadeController.dispose();
    scaleController.dispose();
    fadeOutStarsController.dispose();
    flashController.dispose();
    fadeInImageController.dispose();
  }
}
