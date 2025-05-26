import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hollows_go/screens/homescreen.dart';
import 'package:provider/provider.dart';
import '../providers/dialeg_provider.dart';
import '../widgets/dialogue_widget.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DialogueProvider>(context, listen: false)
          .loadTutorialDialogue('tutorial');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    if (_navigating) return;
    _navigating = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  // Limitem punts a 4 i ajustem quin bloc mostrar segons la posició actual
  List<int> _visibleDots(int currentIndex, int total) {
    const maxVisible = 4;
    if (total <= maxVisible) {
      return List.generate(total, (i) => i);
    } else {
      if (currentIndex <= 1) {
        return [0, 1, 2, 3];
      } else if (currentIndex >= total - 2) {
        return [total - 4, total - 3, total - 2, total - 1];
      } else {
        return [
          currentIndex - 1,
          currentIndex,
          currentIndex + 1,
          currentIndex + 2
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DialogueProvider>(context);
    final totalSteps = provider.currentDialogue.length;
    final currentIndex = provider.currentIndex;

    return Scaffold(
      body: totalSteps == 0
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'lib/images/tutorial_screen/fons_tutorial.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: currentIndex == totalSteps - 1
                              ? const NeverScrollableScrollPhysics() // bloqueja swipe a l'últim
                              : const BouncingScrollPhysics(),
                          itemCount: totalSteps,
                          onPageChanged: (index) {
                            if (index >= totalSteps) {
                              _navigateToHome();
                            } else {
                              if (index > provider.currentIndex) {
                                provider.nextTutorialStep();
                              } else if (index < provider.currentIndex) {
                                provider.previousTutorialStep();
                              }
                            }
                          },
                          itemBuilder: (context, index) {
                            return AnimatedBuilder(
                              animation: _pageController,
                              builder: (context, child) {
                                double value = 1.0;
                                if (_pageController.position.haveDimensions) {
                                  value = (_pageController.page ?? 0) - index;
                                  value =
                                      (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                                }
                                return Center(
                                  child: Transform.scale(
                                    scale: value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          'lib/images/tutorial_screen/Pas_$index.png',
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Center(
                                              child: Text(
                                                'No s\'ha trobat la imatge',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Punts limitats a 4
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            _visibleDots(currentIndex, totalSteps).map((index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 12 : 8,
                            height: currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      if (provider.isLastStep)
                        ElevatedButton(
                          onPressed: _navigateToHome,
                          child: const Text('Finalitzar'),
                        ),

                      const SizedBox(height: 12),

                      DialogueWidget(
                        characterName: 'KON',
                        nameColor: const Color.fromARGB(255, 233, 179, 3),
                        bubbleColor: Colors.blueGrey.shade700.withOpacity(0.85),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
