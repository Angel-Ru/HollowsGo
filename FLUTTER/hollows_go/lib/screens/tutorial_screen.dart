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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DialogueProvider>(context);

    return Scaffold(
      body: provider.currentDialogue.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // 📸 Fons amb imatge
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'lib/images/tutorial_screen/fons_tutorial.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🌫️ Blur + foscor
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),

                // 🔽 Contingut del tutorial
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // 🖼️ Slider de targetes amb PageView
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: provider.currentDialogue.length,
                          onPageChanged: (index) {
                            if (index > provider.currentIndex) {
                              provider.nextTutorialStep();
                            } else if (index < provider.currentIndex) {
                              provider.previousTutorialStep();
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

                      // 🔵 Punts d’indicador de pàgina
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          provider.currentDialogue.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: provider.currentIndex == index ? 12 : 8,
                            height: provider.currentIndex == index ? 12 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: provider.currentIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🔘 Botó finalitzar només si és l'últim pas
                      if (provider.isLastStep)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          },
                          child: const Text('Finalitzar'),
                        ),

                      const SizedBox(height: 12),

                      // 💬 Diàleg del tutorial
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
