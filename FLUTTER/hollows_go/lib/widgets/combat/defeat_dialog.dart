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
    return Center(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        backgroundColor: Colors.black.withOpacity(0.5),
        child: Container(
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
                "Has perdut en combat, cura't les ferides",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade300,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'lib/images/Kon.gif',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade200,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
      ),
    );
  }
}
