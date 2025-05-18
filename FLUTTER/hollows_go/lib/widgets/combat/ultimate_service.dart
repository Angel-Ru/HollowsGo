import 'package:flutter/material.dart';
import 'package:hollows_go/screens/combatscreen.dart';
import 'dart:async';

import 'ultimate_animation.dart';
import 'ultimate_video.dart';

class UltimateService {
  OverlayEntry? _overlayEntry;

  Future<void> executeShinjiUlti(
      BuildContext context, Function onDamageApplied) async {
    // Mostrar animación + audio con overlay
    final completer = Completer();

    _overlayEntry = OverlayEntry(
      builder: (context) => UltimateAnimation(
        onCompleted: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          completer.complete();
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    // Esperar a que termine la animación + audio
    await completer.future;

    // Mostrar video en diálogo
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UltimateVideo(
        onVideoEnd: () {
          // Se puede hacer algo al acabar video si quieres
        },
      ),
    );

    // Inflige daño
    onDamageApplied(100);

    // Rota pantalla sin perder estado
    await _rotateScreen(context);
  }

  Future<void> _rotateScreen(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CombatScreenWrapper(isRotated: true),
      ),
    );
  }
}

class CombatScreenWrapper extends StatelessWidget {
  final bool isRotated;
  const CombatScreenWrapper({required this.isRotated, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: isRotated ? 3.14159 : 0,
      child: CombatScreen(),
    );
  }
}
