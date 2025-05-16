import 'package:flutter/material.dart';

class VictoryDialog extends StatelessWidget {
  final int coins;
  final int exp;
  final VoidCallback onContinue;

  const VictoryDialog({
    required this.coins,
    required this.exp,
    required this.onContinue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Has guanyat!"),
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
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: coins),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) => Text(
              "+$value monedes",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: exp),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) => Text(
              "+$value EXP",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
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
