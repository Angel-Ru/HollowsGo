import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemChrome
import 'package:hollows_go/screens/combatscreen.dart';

import 'ultimate_animation.dart';
import 'ultimate_video.dart';

class UltimateService {
  OverlayEntry? _overlayEntry;

  Future<void> executeShinjiUlti(
      BuildContext context, Function onDamageApplied) async {
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

    onDamageApplied(100);

    // Girar pantalla 180 grados (portrait invertido)
    await _rotateScreenUpsideDown();
  }

  Future<void> _rotateScreenUpsideDown() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> _rotateScreenToPortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
