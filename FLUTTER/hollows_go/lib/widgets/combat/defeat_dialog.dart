import 'package:flutter/material.dart';

class DefeatDialog extends StatelessWidget {
  final VoidCallback onContinue;

  const DefeatDialog({required this.onContinue, super.key});

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
          onPressed: onContinue,
          child: const Text("Continuar"),
        ),
      ],
    );
  }
}
