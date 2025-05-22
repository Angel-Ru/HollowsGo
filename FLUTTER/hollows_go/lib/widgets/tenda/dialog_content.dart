import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'animated_star_rows.dart';
import 'dialog_animations.dart';

class DialogContent extends StatefulWidget {
  final Map<String, dynamic>? skin;
  final bool isDuplicate;
  final DialogAnimationManager animations;

  const DialogContent({
    super.key,
    required this.skin,
    required this.isDuplicate,
    required this.animations,
  });

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  bool _showStars = true;
  bool _showImage = false;
  bool _showFlash = false;

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final isDuplicate = widget.isDuplicate;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: NetworkImage(
              'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.8), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isDuplicate ? '🔁 Skin Repetida! 🔁' : '🎉 Nova Skin Obtinguda!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade300,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (!isDuplicate) ...[
            if (_showStars)
              FadeTransition(
                opacity: widget.animations.fadeOutStarsAnimation,
                child: AnimatedStarRow(
                  count: _getStarCount(skin),
                  onCompleted: () async {
                    await widget.animations.fadeOutStarsController.forward();
                    setState(() {
                      _showStars = false;
                      _showFlash = true;
                    });
                    await widget.animations.flashController.forward();
                    await Future.delayed(const Duration(milliseconds: 500));
                    setState(() {
                      _showFlash = false;
                      _showImage = true;
                    });
                    await widget.animations.fadeInImageController.forward();
                  },
                ),
              ),
            if (_showFlash)
              FadeTransition(
                opacity: widget.animations.flashAnimation,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      radius: 0.7,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.orangeAccent.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
              ),
            if (_showImage)
              FadeTransition(
                opacity: widget.animations.fadeInImageAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _getBorderColor(skin),
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            skin?['imatge'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Has desbloquejat la skin:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: SizedBox(
                        height: 40,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ScaleAnimatedText(
                              skin?['nom'] ?? '',
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          repeatForever: true,
                          pause: const Duration(milliseconds: 100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (isDuplicate) ...[
            Image.asset(
              'lib/images/skinrepetida.gif',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            const Text(
              'Ja tens aquesta skin.\nSe ha retornat el cost del gacha',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
          const SizedBox(height: 10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orangeAccent.shade200,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Acceptar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBorderColor(Map<String, dynamic>? skin) {
    if (skin == null) return Colors.grey;
    if (skin['habilitat_llegendaria'] == true) {
      return Colors.amber.shade400;
    }
    switch (skin['categoria']) {
      case 1:
        return Colors.grey.shade400;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }

  int _getStarCount(Map<String, dynamic>? skin) {
    if (skin == null) return 0;
    if (skin['habilitat_llegendaria'] == true) return 5;
    return skin['categoria'] ?? 0;
  }
}
