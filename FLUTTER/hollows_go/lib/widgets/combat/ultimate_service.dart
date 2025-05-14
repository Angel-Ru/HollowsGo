import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hollows_go/screens/combatscreen.dart';
import 'dart:async';

class UltimateService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late VideoPlayerController _videoController;

  Future<void> executeShinjiUlti(
      BuildContext context, Function onDamageApplied) async {
    // Mostrar imagen horizontal y reproducir audio
    _showUltimateFrame(context);
    await _playUltimateSound();

    // Espera 5 segundos
    await Future.delayed(Duration(seconds: 5));

    // Cierra imagen
    Navigator.of(context).pop();

    // Reproduce video en un dialogo
    await _playUltimateVideo(context);

    // Inflige daño
    onDamageApplied(100);

    // Rota sin perder estado
    await _rotateScreen(context);
  }

  void _showUltimateFrame(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Image.asset(
              'assets/special_attack/shinji/marco_prova.png',
              width: MediaQuery.of(context).size.width,
              height: 100,
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    );
  }

  Future<void> _playUltimateSound() async {
    try {
      await _audioPlayer.play(AssetSource('special_attack/shinji/yokoso.mp3'));
    } catch (e) {
      print("Error al reproducir el audio: $e");
    }
  }

  Future<void> _playUltimateVideo(BuildContext context) async {
    _videoController = VideoPlayerController.asset(
        'assets/special_attack/shinji/shinji_vid.mp4');

    await _videoController.initialize();
    _videoController.play();

    final completer = Completer();

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration &&
          !_videoController.value.isPlaying &&
          !completer.isCompleted) {
        Navigator.of(context).pop(); // Cierra el diálogo del video
        completer.complete();
      }
    });

    // Mostrar el video
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: VideoPlayer(_videoController),
        ),
      ),
    );

    await completer.future;
    await _videoController.dispose();
  }

  Future<void> _rotateScreen(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CombatScreenWrapper(isRotated: true),
      ),
    );
  }
}

class CombatScreenWrapper extends StatelessWidget {
  final bool isRotated;
  const CombatScreenWrapper({required this.isRotated});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: isRotated ? 3.14159 : 0,
      child: CombatScreen(),
    );
  }
}
