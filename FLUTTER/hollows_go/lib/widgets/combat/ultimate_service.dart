import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/providers/habilitat_provider.dart';
import 'ultimate_animation.dart';
import 'ultimate_video.dart';

class UltimateService {
  OverlayEntry? _overlayEntry;

  /// Método principal para ejecutar la ulti correspondiente a la skin actual
  Future<void> executeUltimateForSkin({
    required BuildContext context,
    required Function(int) onDamageApplied,
    required VoidCallback onEnemyDefeated,
  }) async {
    final habilitatProvider =
        Provider.of<HabilitatProvider>(context, listen: false);
    final habilitat = habilitatProvider.habilitat;

    if (habilitat == null) {
      debugPrint("No hay habilitat llegendaria para esta skin.");
      return;
    }

    switch (habilitat.id) {
      case 3:
        // Shinji's ulti
        await _executeShinjiUlti(context, onDamageApplied, onEnemyDefeated);
        break;

      // Aquí podrás añadir nuevas ultimates fácilmente:
      // case 4:
      //   await _executeNouPersonatgeUlti(context, onDamageApplied, onEnemyDefeated);
      //   break;

      default:
        debugPrint(
            "No hay implementación para la habilitat ID: ${habilitat.id}");
        break;
    }
  }

  /// -------------------------
  /// Ulti de Shinji (ID 3)
  /// -------------------------
  Future<void> _executeShinjiUlti(
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
        onVideoEnd: () {},
      ),
    );

    await _rotateScreenUpsideDown();

    onDamageApplied(100);

    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    if (combatProvider.enemicHealth <= 0) {
      await _rotateScreenToPortrait();
      onEnemyDefeated();
    }
  }

  /// -------------------------
  /// Utilidades de orientación
  /// -------------------------
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
