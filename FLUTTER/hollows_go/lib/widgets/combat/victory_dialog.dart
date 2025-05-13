import 'package:flutter/material.dart';

class VictoryDialog extends StatelessWidget {
  final int coins;
  final VoidCallback onContinue;

  const VictoryDialog({
    required this.coins,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Has guanyat"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "+$coins",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
