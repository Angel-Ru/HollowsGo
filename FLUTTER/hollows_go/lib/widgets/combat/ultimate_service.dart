import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemChrome
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/screens/combatscreen.dart';
import 'package:provider/provider.dart';

import 'ultimate_animation.dart';
import 'ultimate_video.dart';

class UltimateService {
  OverlayEntry? _overlayEntry;

  Future<void> executeShinjiUlti(
    BuildContext context,
    Function(int) onDamageApplied,
    VoidCallback onEnemyDefeated,
  ) async {
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

    await completer.future;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UltimateVideo(
        onVideoEnd: () {
          // Acción opcional al terminar el video
        },
      ),
    );

    // Primero gira pantalla 180 grados (portrait invertido)
    await _rotateScreenUpsideDown();

    // Aplica daño
    onDamageApplied(100);

    // Comprobar si enemigo murió para mostrar diálogo victoria
    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    if (combatProvider.enemicHealth <= 0) {
      await _rotateScreenToPortrait();
      onEnemyDefeated();
      return;
    }

    // Si no muere, deja la pantalla girada (la puedes volver a retrato cuando termine el combate)
  }

  Future<void> _rotateScreenUpsideDown() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _rotateScreenToPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
