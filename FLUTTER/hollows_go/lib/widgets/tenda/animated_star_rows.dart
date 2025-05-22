import 'package:flutter/material.dart';

class AnimatedStarRow extends StatefulWidget {
  final int count;
  final VoidCallback? onCompleted;

  const AnimatedStarRow({required this.count, this.onCompleted, super.key});

  @override
  State<AnimatedStarRow> createState() => _AnimatedStarRowState();
}

class _AnimatedStarRowState extends State<AnimatedStarRow>
    with TickerProviderStateMixin {
  late List<bool> _starVisible;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _starVisible = List.generate(widget.count, (_) => false);
    _controllers = List.generate(
      widget.count,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );
    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.5, end: 1.2)
          .chain(CurveTween(curve: Curves.elasticOut))
          .animate(controller);
    }).toList();
    _showStarsSequentially();
  }

  Future<void> _showStarsSequentially() async {
    for (int i = 0; i < widget.count; i++) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _starVisible[i] = true;
      });
      _controllers[i].forward();
    }
    widget.onCompleted?.call();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.count, (index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _starVisible[index] ? 1.0 : 0.0,
          child: ScaleTransition(
            scale: _scaleAnimations[index],
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  colors: [
                    Colors.amber.shade700,
                    Colors.amber.shade300,
                    Colors.yellow.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(rect);
              },
              blendMode: BlendMode.srcATop,
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        );
      }),
    );
  }
}
