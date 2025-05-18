// defeat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefeatDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const DefeatDialog({required this.onContinue, super.key});

  Future<void> _restorePortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Has perdut"),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254233/COMBATSCREEN/yhh1xy0qy4lumw9v7jtd.png',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await _restorePortrait();
            onContinue();
          },
          child: const Text("Continuar"),
        ),
      ],
    );
  }
}
