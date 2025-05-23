import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/providers/habilitat_provider.dart';
import 'ultimate_animation.dart';
import 'ultimate_video.dart';

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

      case 6:
        await _executeUlti(
          context,
          imageAsset:
              'assets/special_attack/kenpachi_tybw/marco_kenpachi_tybw.png',
          audioAsset: 'special_attack/kenpachi_tybw/kenpachi_tybw_aud.mp3',
          videoAsset:
              'assets/special_attack/kenpachi_tybw/kenpachi_tybw_vid.mp4',
          damage: 1000,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;
//Metodo que habia antes hay que hacer uno nuevo que funcione correctamente
// ultimate_service.dart

      case 7:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);

        await _executeUlti(
          context,
          imageAsset:
              'assets/special_attack/kenpachi_ull/marco_kenpachi_ull.png',
          audioAsset: 'special_attack/kenpachi_ull/kenpachi_ull_aud.mp3',
          videoAsset: 'assets/special_attack/kenpachi_ull/kenpachi_ull_vid.mp4',
          damage: 0, // no hace daño directo
          rotateScreen: false,
          onDamageApplied: (_) {
            // Aplicar el buff de +300 al próximo ataque aliado
            combatProvider.buffPlayerAttack(300);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      case 8:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/ichigo/marco_ichigo.png',
          audioAsset: 'special_attack/ichigo/ichigo_aud.mp3',
          videoAsset: 'assets/special_attack/ichigo/ichigo_vid.mp4',
          damage: 350,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      case 19: // ID para el debuff
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/as_nodt/marco_as_nodt.png',
          audioAsset: 'special_attack/as_nodt/as_nodt_aud.mp3',
          videoAsset: 'assets/special_attack/as_nodt/as_nodt_vid.mp4',
          damage: 0, // No hace daño directo
          rotateScreen: false,
          onDamageApplied: (_) {
            final combatProvider =
                Provider.of<CombatProvider>(context, listen: false);
            combatProvider.applyEnemyAttackDebuff(200); // Reduce 200 de daño
            debugPrint('[DEBUG] Debuff aplicado: -200 al ataque enemigo');
          },
          onEnemyDefeated: onEnemyDefeated,
        );

// GRIMMJOW
      case 11:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);

        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/grimmjow/marco_grimmjow.png',
          audioAsset: 'special_attack/grimmjow/grimmjow_aud.mp3',
          videoAsset: 'assets/special_attack/grimmjow/grimmjow_vid.mp4',
          damage: 100, // no hace daño directo
          rotateScreen: false,
          onDamageApplied: (_) {
            // Aplicar el buff de +300 al próximo ataque aliado
            combatProvider.buffPlayerAttack(300);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      case 12:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/ulquiorra/marco_ulquiorra.png',
          audioAsset: 'special_attack/ulquiorra/ulquiorra_aud.mp3',
          videoAsset: 'assets/special_attack/ulquiorra/ulquiorra_vid.mp4',
          damage: 350,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      case 18: // Tosen - Buff i Debuff + fons negre + baixa lluminositat
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);

        // Estableix la lluminositat al mínim
        try {
          await ScreenBrightness().setScreenBrightness(0.0);
        } catch (e) {
          debugPrint("Error al establir lluminositat mínima: $e");
        }

        // Crea un overlay temporal amb fons negre
        final overlay = OverlayEntry(
          builder: (context) => Positioned.fill(
            child: Container(
              color: Colors.black,
              child: Image.asset(
                'assets/special_attack/tosen/fons_negre.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

        Overlay.of(context).insert(overlay);

        // Executa l'animació de l'ulti normalment
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/tosen/marco_tosen.png',
          audioAsset: 'special_attack/tosen/tosen_aud.mp3',
          videoAsset: 'assets/special_attack/tosen/tosen_vid.mp4',
          damage: 0, // No fa dany directe, només buffs/debuffs
          rotateScreen: false,
          onDamageApplied: (_) {
            combatProvider.buffPlayerAttack(100);
            combatProvider.applyEnemyAttackDebuff(150);
            debugPrint("[DEBUG] Buff +100 i Debuff -150 aplicats per Tosen");
          },
          onEnemyDefeated: onEnemyDefeated,
        );

        overlay.remove();

        // Restaura la lluminositat (opcional, si vols que torni al valor original després)
        try {
          await ScreenBrightness().resetScreenBrightness();
        } catch (e) {
          debugPrint("Error al restaurar lluminositat: $e");
        }
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
    final videoController = VideoPlayerController.asset(videoAsset);
    await videoController.initialize(); // ⏳ Precarga del video

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

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => UltimateVideo(
        videoAsset: videoAsset,
        controller: videoController, // ✅ Reutiliza controlador precargado
        onVideoEnd: () {},
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
