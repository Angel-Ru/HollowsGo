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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DialogueProvider>(context, listen: false)
          .loadTutorialDialogue('tutorial');
    });
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
                      // 🖼️ Imatge del pas actual amb lliscament
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            if (details.primaryVelocity != null) {
                              if (details.primaryVelocity! < -200) {
                                // Lliscament cap a l'esquerra (següent)
                                if (!provider.isLastStep) {
                                  provider.nextTutorialStep();
                                }
                              } else if (details.primaryVelocity! > 200) {
                                // Lliscament cap a la dreta (enrere)
                                if (!provider.isFirstStep) {
                                  provider.previousTutorialStep();
                                }
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'lib/images/tutorial_screen/Pas_${provider.currentIndex}.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Text(
                                        'No s\'ha trobat la imatge',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // Fletxa esquerra
                              if (!provider.isFirstStep)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Icon(Icons.arrow_back_ios,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                ),

                              // Fletxa dreta
                              if (!provider.isLastStep)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: Icon(Icons.arrow_forward_ios,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                ),
                            ],
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
                        nameColor: const Color.fromARGB(255, 84, 223, 4),
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
