import 'dart:async';
import '../../imports.dart';

class SkinSwiperPopup extends StatefulWidget {
  final List<Map<String, dynamic>> skins;
  final int currentIndex;  // nou camp

  const SkinSwiperPopup({
    required this.skins,
    required this.currentIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<SkinSwiperPopup> createState() => _SkinSwiperPopupState();
}

class _SkinSwiperPopupState extends State<SkinSwiperPopup> with TickerProviderStateMixin {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  List<bool> _visibleStars = [false, false, false, false];

  Color get _activeColor {
    if (widget.currentIndex == 1) {
      return Colors.blueAccent;
    } else if (widget.currentIndex == 2) {
      return Colors.purple[700]!;
    } else {
      return Colors.orangeAccent;
    }
  }

  Color get _borderColor {
    if (widget.currentIndex == 1) {
      return Colors.blueAccent.withOpacity(0.6);
    } else if (widget.currentIndex == 2) {
      return Colors.purple[700]!.withOpacity(0.6);
    } else {
      return Colors.orange.withOpacity(0.6);
    }
  }

  Color get _textColor {
    if (widget.currentIndex == 1) {
      return Colors.blueAccent;
    } else if (widget.currentIndex == 2) {
      return Colors.purple[700]!;;
    } else {
      return Colors.orange;
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75);
    _startTimer();
    _animateStars();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        setState(() => _visibleStars = [false, false, false, false]);
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _currentPage = (_currentPage + 1) % widget.skins.length;
          });
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
          _animateStars();
        });
      }
    });
  }

  void _animateStars() {
    for (int i = 0; i < 4; i++) {
      Future.delayed(Duration(milliseconds: 300 + (i * 200)), () {
        if (mounted) {
          setState(() => _visibleStars[i] = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStarRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedOpacity(
          opacity: _visibleStars[index] ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(Icons.star_rounded, color: _activeColor, size: 20),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        height: 440,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.95),
              widget.currentIndex == 1
                  ? Colors.blueGrey.withOpacity(0.8)
                  : widget.currentIndex == 2
                      ? Colors.purple[700]!.withOpacity(0.4)
                      : const Color(0xFF2F1B0E).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Skins destacades',
              style: TextStyle(
                color: _textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.skins.length,
                itemBuilder: (context, index) {
                  final skin = widget.skins[index];
                  final imageUrl = skin['imatge'];
                  final nom = skin['nom'] ?? 'Sense nom';

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = (_pageController.page! - index).abs().clamp(0.0, 1.0);
                        value = 1 - (value * 0.1);
                      }
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey[900],
                          border: Border.all(color: _borderColor, width: 2),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.error, color: Colors.redAccent)),
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                                  color: Colors.black.withOpacity(0.7),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        nom,
                                        style: TextStyle(
                                          color: _activeColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      _buildStarRow(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close, color: _activeColor),
              label: Text(
                'Tancar',
                style: TextStyle(color: _activeColor),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
