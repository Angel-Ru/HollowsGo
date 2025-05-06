import '../imports.dart';

class DialogueProvider extends ChangeNotifier {
  int _dialogIndex = 0;
  List<String> _dialogues = [];
  List<String> _characterImages = [];
  String _currentImage = '';
  String _currentCharacter = '';

  String get currentDialogue =>
      _dialogues.isNotEmpty ? _dialogues[_dialogIndex] : "";
  String get currentImage => _currentImage;
  String get currentCharacter => _currentCharacter;

  Future<void> loadDialogueFromJson(String characterKey) async {
    if (_currentCharacter == characterKey) return; // Ya están cargados

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

    String newImage;
    do {
      newImage = _characterImages[Random().nextInt(_characterImages.length)];
    } while (newImage == _currentImage);

    _currentImage = newImage;
    notifyListeners();
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
