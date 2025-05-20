import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/providers/habilitat_provider.dart';
import 'ultimate_animation.dart';
import 'ultimate_video.dart'; // Asegúrate que apunta al archivo correcto (ahora UltimateVideoPlayerScreen)

class UltimateService {
  OverlayEntry? _overlayEntry;

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
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/shinji/marco_shinji.png',
          audioAsset: 'special_attack/shinji/shinji_aud.mp3',
          videoAsset: 'assets/special_attack/shinji/shinji_vid.mp4',
          damage: 100,
          rotateScreen: true,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      case 4:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/yamamoto/marco_yamamoto.png',
          audioAsset: 'special_attack/yamamoto/yamamoto_aud.mp3',
          videoAsset: 'assets/special_attack/yamamoto/yamamoto_vid.mp4',
          damage: 1000,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      default:
        debugPrint(
            "No hay implementación para la habilitat ID: ${habilitat.id}");
        break;
    }
  }

  Future<void> _executeUlti(
    BuildContext context, {
    required String imageAsset,
    required String audioAsset,
    required String videoAsset,
    required int damage,
    required bool rotateScreen,
    required Function(int) onDamageApplied,
    required VoidCallback onEnemyDefeated,
  }) async {
    final completer = Completer();

    _overlayEntry = OverlayEntry(
      builder: (context) => UltimateAnimation(
        imageAsset: imageAsset,
        audioAsset: audioAsset,
        onCompleted: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
          completer.complete();
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    await completer.future;

    // ✅ Ahora usando la pantalla estilo CombatIntroVideoScreen
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UltimateVideo(
          videoAsset: videoAsset,
          onVideoEnd: () {},
        ),
      ),
    );

    if (rotateScreen) await _rotateScreenUpsideDown();

    onDamageApplied(damage);

    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    if (combatProvider.enemicHealth <= 0) {
      if (rotateScreen) await _rotateScreenToPortrait();
      onEnemyDefeated();
    }
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
