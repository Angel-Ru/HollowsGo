import '../imports.dart';

/*
Aquesta és la classe DialogueProvider. Aquesta classe s'encarrega de gestionar els diàlegs de l'aplicació.
*/

class DialogueProvider extends ChangeNotifier {
  int _dialogIndex = 0;
  List<String> _dialogues = [];
  List<String> _characterImages = [];
  String _currentImage = '';

  int _libraryDialogIndex = 0;
  List<String> _libraryDialogues = [];
  List<String> _libraryCharacterImages = [];
  String _currentLibraryImage = '';

  DialogueProvider();



  Future<void> loadDialogueFromJson(String characterKey,{bool isLibrary = false}) async {
    final String response = await rootBundle.loadString('assets/dialogues.json');
    final data = json.decode(response);

    if (!data.containsKey(characterKey)) return;

    final List<String> dialogues = List<String>.from(data[characterKey]["dialogues"]);
    final List<String> images = List<String>.from(data[characterKey]["images"]);

    setDialogueData(dialogues, images, isLibrary: isLibrary);
  }


  void setDialogueData(List<String> dialogues, List<String> images,
      {bool isLibrary = false}) {
    if (isLibrary) {
      _libraryDialogues = dialogues;
      _libraryCharacterImages = images;
      _currentLibraryImage =
          _libraryCharacterImages.isNotEmpty ? _libraryCharacterImages[0] : '';
      _libraryDialogIndex = 0;
    } else {
      _dialogues = dialogues;
      _characterImages = images;
      _currentImage = _characterImages.isNotEmpty ? _characterImages[0] : '';
      _dialogIndex = 0;
    }
    notifyListeners();
  }

  String get currentDialogue =>
      _dialogues.isNotEmpty ? _dialogues[_dialogIndex] : "";
  String get currentImage => _currentImage;

  String get currentLibraryDialogue => _libraryDialogues.isNotEmpty
      ? _libraryDialogues[_libraryDialogIndex]
      : "";
  String get currentLibraryImage => _currentLibraryImage;

  void nextDialogue({bool isLibrary = false}) {
    if (isLibrary) {
      if (_libraryDialogues.isEmpty || _libraryCharacterImages.isEmpty) return;

      _libraryDialogIndex =
          (_libraryDialogIndex + 1) % _libraryDialogues.length;

      String newImage;
      do {
        newImage = _libraryCharacterImages[
            Random().nextInt(_libraryCharacterImages.length)];
      } while (newImage == _currentLibraryImage);

      _currentLibraryImage = newImage;
    } else {
      if (_dialogues.isEmpty || _characterImages.isEmpty) return;

      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;

      String newImage;
      do {
        newImage = _characterImages[Random().nextInt(_characterImages.length)];
      } while (newImage == _currentImage);

      _currentImage = newImage;
    }
    notifyListeners();
  }

  void resetDialogue({bool isLibrary = false}) {
    if (isLibrary) {
      _libraryDialogues = [];
      _libraryCharacterImages = [];
      _libraryDialogIndex = 0;
      _currentLibraryImage = '';
    } else {
      _dialogues = [];
      _characterImages = [];
      _dialogIndex = 0;
      _currentImage = '';
    }
    notifyListeners();
  }


}
