import '../imports.dart';

/*
Aquesta és la classe UIProvider. Aquesta classe s'encarrega de gestionar la informació de la UI de l'aplicació.
*/

class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int index) {
    this._selectedMenuOpt = index;
    notifyListeners();
  }
}
