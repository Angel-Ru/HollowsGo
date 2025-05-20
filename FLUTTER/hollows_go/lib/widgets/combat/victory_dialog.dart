import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

  Future<void> _restorePortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                  'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "🏆 Has guanyat!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade300,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png',
                  ),
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: coins),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) => Text(
                    "+$value monedes",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: exp.toDouble()),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    double percentage = (value / exp).clamp(0.0, 1.0);
                    return Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: percentage,
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.orange),
                              minHeight: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "+${value.toInt()} EXP",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade200,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await _restorePortrait();
                    onContinue();
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
