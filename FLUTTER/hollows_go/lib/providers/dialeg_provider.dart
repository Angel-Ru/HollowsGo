import 'dart:math';
import 'package:flutter/material.dart';

class DialogueProvider extends ChangeNotifier {
  int _dialogIndex = 0;
  List<String> _dialogues = [];
  List<String> _characterImages = [];
  String _currentImage = '';

  DialogueProvider();

  void setDialogueData(List<String> dialogues, List<String> images) {
    _dialogues = dialogues;
    _characterImages = images;
    _currentImage = _characterImages.isNotEmpty ? _characterImages[0] : '';
    _dialogIndex = 0;
    notifyListeners();
  }

  String get currentDialogue => _dialogues.isNotEmpty ? _dialogues[_dialogIndex] : "";
  String get currentImage => _currentImage;

  void nextDialogue() {
    if (_dialogues.isEmpty || _characterImages.isEmpty) return;

    _dialogIndex = (_dialogIndex + 1) % _dialogues.length;

    String newImage;
    do {
      newImage = _characterImages[Random().nextInt(_characterImages.length)];
    } while (newImage == _currentImage);

    _currentImage = newImage;
    notifyListeners();
  }

// Mètode per reiniciar els valors
  void resetDialogue() {
    _dialogues = [];
    _characterImages = [];
    _dialogIndex = 0;
    _currentImage = '';
    notifyListeners();  
  }
}
