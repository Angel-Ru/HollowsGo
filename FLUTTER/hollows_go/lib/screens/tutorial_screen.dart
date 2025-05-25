import 'package:flutter/material.dart';
import 'package:hollows_go/providers/dialeg_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/dialogue_widget.dart'; // Assegura't que tens aquest widget

class TutorialStep {
  final String dialogue;
  final String imageAsset;

  TutorialStep({required this.dialogue, required this.imageAsset});
}

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final List<TutorialStep> _steps = [
    TutorialStep(
      dialogue: "Hola! Sóc Shinji. Et guiaré per l'app.",
      imageAsset: 'assets/images/shinji_1.png',
    ),
    TutorialStep(
      dialogue:
          "Aquí tens la configuració per ajustar el volum i la lluminositat.",
      imageAsset: 'assets/images/shinji_2.png',
    ),
    TutorialStep(
      dialogue: "Si vols, pots tancar sessió des d'aquí.",
      imageAsset: 'assets/images/shinji_3.png',
    ),
  ];

  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Tutorial acabat, pots fer el que vulguis aquí
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      appBar: AppBar(title: Text('Tutorial')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Image.asset(step.imageAsset),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              step.dialogue,
              style: TextStyle(fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: _nextStep,
            child: Text(
                _currentStep == _steps.length - 1 ? 'Finalitzar' : 'Següent'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
