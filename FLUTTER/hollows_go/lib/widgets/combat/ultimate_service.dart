import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hollows_go/providers/skins_enemics_personatges.dart';
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
      debugPrint("No hi ha habilitat llegendària per a aquesta skin.");
      return;
    }

    switch (habilitat.id) {
      //ULTI SHINJI
      case 3:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/shinji/marco_shinji.png',
          audioAsset: 'special_attack/shinji/shinji_aud.mp3',
          videoAsset: 'assets/special_attack/shinji/shinji_vid.mp4',
          damage: 0,
          rotateScreen: true,
          onDamageApplied: (_) {
            onDamageApplied(200);
            combatProvider.applyEnemyAttackDebuff(100);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI YAMAMOTO
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

      //ULTI KENPACHI ARC NOU
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

      //ULTI KENPACHI PARCHE
      case 7:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        await _executeUlti(
          context,
          imageAsset:
              'assets/special_attack/kenpachi_ull/marco_kenpachi_ull.png',
          audioAsset: 'special_attack/kenpachi_ull/kenpachi_ull_aud.mp3',
          videoAsset: 'assets/special_attack/kenpachi_ull/kenpachi_ull_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) => combatProvider.buffPlayerAttack(300),
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI ICHIGO
      case 8:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/ichigo/marco_ichigo.png',
          audioAsset: 'special_attack/ichigo/ichigo_aud.mp3',
          videoAsset: 'assets/special_attack/ichigo/ichigo_vid.mp4',
          damage: 400,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI YHWACH
      case 9:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);

        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/yhwach/marco_yhwach.png',
          audioAsset: 'special_attack/yhwach/yhwach_aud.mp3',
          videoAsset: 'assets/special_attack/yhwach/yhwach_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            combatProvider.setPlayerImmune(true);
            debugPrint(
                "🛡️ Escut de Yhwach activat! L'aliat ara és immune al pròxim atac.");
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI ICHIBE
      case 10:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        final skinProvider = Provider.of<SkinsEnemicsPersonatgesProvider>(
          context,
          listen: false,
        );

        final enemyName = skinProvider.selectedSkin?.personatgeNom ?? "Enemic";
        final enemyMaxHealth =
            (skinProvider.selectedSkin?.vida ?? 1000).toDouble();
        final enemyAttack = (skinProvider.selectedSkin?.malTotal ?? 50) * 2;

        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/ichibe/marco_ichibe.png',
          audioAsset: 'special_attack/ichibe/ichibe_aud.mp3',
          videoAsset: 'assets/special_attack/ichibe/ichibe_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            combatProvider.triggerIchibeUltiEffect();

            final result = combatProvider.ichibeUltimateEffect(
              enemyName: enemyName,
              enemyMaxHealth: enemyMaxHealth,
              enemyAttack: enemyAttack,
            );

            combatProvider.applyEnemyAttackDebuff(result['attackDebuff']);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI GRIMMJOW
      case 11:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/grimmjow/marco_grimmjow.png',
          audioAsset: 'special_attack/grimmjow/grimmjow_aud.mp3',
          videoAsset: 'assets/special_attack/grimmjow/grimmjow_vid.mp4',
          damage: 100,
          rotateScreen: false,
          onDamageApplied: (_) => combatProvider.buffPlayerAttack(300),
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI ULQUIORRA
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

      //ULTI AIZEN
      case 13:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/aizen/marco_aizen.png',
          audioAsset: 'special_attack/aizen/aizen_aud.mp3',
          videoAsset: 'assets/special_attack/aizen/aizen_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            final combatProvider =
                Provider.of<CombatProvider>(context, listen: false);
            combatProvider.applyEnemyAttackDebuff(100);
            onDamageApplied(400);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI SENJUMARU
      case 14:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);

        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/senjumaru/marco_senjumaru.png',
          audioAsset: 'special_attack/senjumaru/senjumaru_aud.mp3',
          videoAsset: 'assets/special_attack/senjumaru/senjumaru_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            combatProvider.activateSenjumaruEffect();
          },
          onEnemyDefeated: onEnemyDefeated,
          skipDeathCheck: true,
        );
        break;

      //ULTI UNOHANA
      case 15:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        final skinProvider = Provider.of<SkinsEnemicsPersonatgesProvider>(
            context,
            listen: false);
        final maxHealth = skinProvider.selectedSkinAliat?.vidaMaxima ??
            1000; // Vida màxima de la skin

        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/unohana/marco_unohana.png',
          audioAsset: 'special_attack/unohana/unohana_aud.mp3',
          videoAsset: 'assets/special_attack/unohana/unohana_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            combatProvider.healPlayer(400, maxHealth);
            combatProvider.applyBleed();
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI GIN
      case 16:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/gin/marco_gin.png',
          audioAsset: 'special_attack/gin/gin_aud.mp3',
          videoAsset: 'assets/special_attack/gin/gin_vid.mp4',
          damage: 450,
          rotateScreen: false,
          onDamageApplied: onDamageApplied,
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI TOSEN
      case 18:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        double originalBrightness = 0.2;

        try {
          originalBrightness = await ScreenBrightness().current;
        } catch (e) {
          debugPrint(
              "No s'ha pogut obtenir la brillantor actual. S'assumeix 0.2");
        }

        bool shouldRestoreBrightness = true;

        void restoreBrightnessIfNeeded() async {
          if (shouldRestoreBrightness) {
            try {
              await ScreenBrightness().setScreenBrightness(originalBrightness);
              shouldRestoreBrightness = false;
            } catch (e) {
              debugPrint("Error restaurant la brillantor original: $e");
            }
          }
        }

        try {
          await _executeUlti(
            context,
            imageAsset: 'assets/special_attack/tosen/marco_tosen.png',
            audioAsset: 'special_attack/tosen/tosen_aud.mp3',
            videoAsset: 'assets/special_attack/tosen/tosen_vid.mp4',
            damage: 0,
            rotateScreen: false,
            onDamageApplied: (_) async {
              try {
                await ScreenBrightness().setScreenBrightness(0.0); // ara
              } catch (e) {
                debugPrint("No s'ha pogut baixar la brillantor: $e");
              }

              combatProvider.buffPlayerAttack(100);
              combatProvider.applyEnemyAttackDebuff(150);
              combatProvider.setOverrideBackground(
                  'assets/special_attack/tosen/fons_negre.png');
            },
            onEnemyDefeated: () {
              restoreBrightnessIfNeeded();
              onEnemyDefeated(); // original callback
            },
            skipDeathCheck: false,
          );
        } catch (e) {
          debugPrint("Error executant ulti: $e");
          restoreBrightnessIfNeeded();
        }

        // Comprovació de derrota manual
        if (combatProvider.aliatHealth <= 0) {
          restoreBrightnessIfNeeded();
        }

        break;

      //ULTI AS NODT
      case 19:
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/as_nodt/marco_as_nodt.png',
          audioAsset: 'special_attack/as_nodt/as_nodt_aud.mp3',
          videoAsset: 'assets/special_attack/as_nodt/as_nodt_vid.mp4',
          damage: 0,
          rotateScreen: false,
          onDamageApplied: (_) {
            final combatProvider =
                Provider.of<CombatProvider>(context, listen: false);
            combatProvider.applyEnemyAttackDebuff(200);
            debugPrint('[DEBUG] Debuff aplicat: -200 al atac enemic');
          },
          onEnemyDefeated: onEnemyDefeated,
        );
        break;

      //ULTI RUKIA
      case 20:
        final combatProvider =
            Provider.of<CombatProvider>(context, listen: false);
        await _executeUlti(
          context,
          imageAsset: 'assets/special_attack/rukia/marco_rukia.png',
          audioAsset: 'special_attack/rukia/rukia_aud.mp3',
          videoAsset: 'assets/special_attack/rukia/rukia_vid.mp4',
          damage: 200,
          rotateScreen: false,
          onDamageApplied: (damage) {
            combatProvider.setEnemyFrozen(true);
            combatProvider.setOverrideBackground(
                'assets/special_attack/rukia/fons_gel.jpg');
            combatProvider.setAllyHealth(combatProvider.aliatHealth - 100);
          },
          onEnemyDefeated: onEnemyDefeated,
        );
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
    bool skipDeathCheck = false,
  }) async {
    final videoController = VideoPlayerController.asset(videoAsset);
    await videoController.initialize();

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
        controller: videoController,
        onVideoEnd: () {},
      ),
    );

    if (rotateScreen) await _rotateScreenUpsideDown();

    onDamageApplied(damage);

    final combatProvider = Provider.of<CombatProvider>(context, listen: false);

    if (!skipDeathCheck && combatProvider.enemicHealth <= 0) {
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
