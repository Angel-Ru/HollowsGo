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
                      // 🖼️ Imatge del pas actual
                      Expanded(
                        child: Container(
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
                      ),

                      const SizedBox(height: 12),

                      // 🔘 Botons Enrere / Següent
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!provider.isFirstStep)
                            ElevatedButton(
                              onPressed: provider.previousTutorialStep,
                              child: const Text('Enrere'),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              if (provider.isLastStep) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()),
                                );
                              } else {
                                provider.nextTutorialStep();
                              }
                            },
                            child: Text(
                                provider.isLastStep ? 'Finalitzar' : 'Següent'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 💬 Diàleg del tutorial
                      DialogueWidget(
                        characterName: 'Shinji',
                        nameColor: Colors.blueAccent,
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
