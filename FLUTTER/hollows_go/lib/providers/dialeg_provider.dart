import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DialogueProvider extends ChangeNotifier {
  int _dialogIndex = 0;
  List<String> _dialogues = [];
  List<String> _characterImages = [];
  String _currentImage = '';
  String _currentCharacter = '';

  // Getter públic per accedir a la llista de diàlegs
  List<String> get dialogues => _dialogues;

  // Getter públic per accedir al diàleg actual
  String get currentDialogue =>
      _dialogues.isNotEmpty ? _dialogues[_dialogIndex] : "";

  String get currentImage => _currentImage;
  String get currentCharacter => _currentCharacter;

  /// Getter públic per accedir a l'índex del diàleg actual
  int get currentIndex => _dialogIndex;

  // Carrega diàlegs i imatges d’un personatge des de JSON
  Future<void> loadDialogueFromJson(String characterKey) async {
    if (_currentCharacter == characterKey) return;

    final String response =
        await rootBundle.loadString('assets/dialogues.json');
    final data = json.decode(response);

    if (!data.containsKey(characterKey)) return;

    final List<String> dialogues =
        List<String>.from(data[characterKey]["dialogues"]);
    final List<String> images = List<String>.from(data[characterKey]["images"]);

    _dialogues = dialogues;
    _characterImages = images;
    _dialogIndex = 0;
    _currentImage = _characterImages.isNotEmpty ? _characterImages[0] : '';
    _currentCharacter = characterKey;

    notifyListeners();
  }

  void nextDialogue() {
    if (_dialogues.isEmpty || _characterImages.isEmpty) return;

    _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
    _currentImage = _getRandomImage();
    notifyListeners();
  }

  // Funció específica pel tutorial: carrega diàlegs i imatges
  Future<void> loadTutorialDialogue(String characterKey) async {
    final String response =
        await rootBundle.loadString('assets/dialogues.json');
    final data = json.decode(response);

    if (!data.containsKey(characterKey)) return;

    _dialogues = List<String>.from(data[characterKey]["dialogues"]);
    _characterImages = List<String>.from(data[characterKey]["images"]);
    _dialogIndex = 0;
    _currentImage = _getRandomImage();
    _currentCharacter = characterKey;

    notifyListeners();
  }

  void nextTutorialStep() {
    if (_dialogIndex < _dialogues.length - 1) {
      _dialogIndex++;
      _currentImage = _getRandomImage();
      notifyListeners();
    }
  }

  void previousTutorialStep() {
    if (_dialogIndex > 0) {
      _dialogIndex--;
      _currentImage = _getRandomImage();
      notifyListeners();
    }
  }

  /// Permet establir l’índex manualment (només dins rang)
  void setCurrentIndex(int index) {
    if (index >= 0 && index < _dialogues.length && index != _dialogIndex) {
      _dialogIndex = index;
      _currentImage = _getRandomImage();
      notifyListeners();
    }
  }

  bool get isFirstStep => _dialogIndex == 0;
  bool get isLastStep => _dialogIndex == _dialogues.length - 1;

  String _getRandomImage() {
    if (_characterImages.isEmpty) return '';
    String newImage;
    do {
      newImage = _characterImages[Random().nextInt(_characterImages.length)];
    } while (newImage == _currentImage && _characterImages.length > 1);
    return newImage;
  }

  void resetDialogue() {
    _dialogues = [];
    _characterImages = [];
    _dialogIndex = 0;
    _currentImage = '';
    _currentCharacter = '';
    notifyListeners();
  }
}
