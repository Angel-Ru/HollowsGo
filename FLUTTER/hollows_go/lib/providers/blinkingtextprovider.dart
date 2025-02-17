import 'package:hollows_go/imports.dart';

class BlinkingTextProvider with ChangeNotifier {
  late AnimationController _controller;
  late Animation<double> _animation;

  BlinkingTextProvider(TickerProvider vsync) {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  Animation<double> get animation => _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
