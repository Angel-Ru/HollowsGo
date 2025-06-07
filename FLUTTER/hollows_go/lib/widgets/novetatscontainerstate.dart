import 'package:flutter/material.dart';

class NovetatsContainer extends StatefulWidget {
  final VoidCallback onTap;

  const NovetatsContainer({Key? key, required this.onTap}) : super(key: key);

  @override
  _NovetatsContainerState createState() => _NovetatsContainerState();
}

class _NovetatsContainerState extends State<NovetatsContainer> {
  final List<String> _novetatsImages = [
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/HomeScreen/Novetats/HOMESCREEN_vlmjp3zogckd7ngaju8x.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/HomeScreen/Novetats/HOMESCREEN_yrfzks7quxo1gxkybluf.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/HomeScreen/Novetats/HOMESCREEN_vj87lcdmygthnw0ilfnj.png?raw=true',
  ];

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startImageRotation();
  }

  void _startImageRotation() {
    Future.delayed(const Duration(seconds: 8), () {
      if (!mounted) return;
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _novetatsImages.length;
      });
      _startImageRotation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 400 / 280, // manté la proporció de la imatge
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 2),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Image.network(
                    key: ValueKey(_novetatsImages[_currentImageIndex]),
                    _novetatsImages[_currentImageIndex],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Align(
                  alignment: const Alignment(0, -0.1),
                  child: Text(
                    'NOVETATS',
                    style: TextStyle(
                      color: const Color(0xFFFFD700),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Harukaze',
                      shadows: const [
                        Shadow(
                          color: Colors.black87,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                      letterSpacing: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
