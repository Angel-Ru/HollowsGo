import '../imports.dart';
import 'package:http/http.dart' as http;

/*
El provider SkinsEnemicsPersonatgesProvider conté la informació dels personatges, les skins i els enemics.
Ens serveix per a poder obtenir les seves dades.
Alguns mètodes principals són el de seleccionar una skin dels enemics de manera aleatòria, actualitzar la vida dels enemics i dels aliats, i obtenir els punts dels enemics. 
*/

class SkinsEnemicsPersonatgesProvider with ChangeNotifier {
  static const String _baseUrl = 'https://${Config.ip}';
  static const String _userPuntsKey = 'userPunts';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';

  int _coinCount = 0;
  int _coinEnemies = 0;
  int? _maxEnemyHealth;
  int? _maxAllyHealth;
  String _username = 'Usuari';
  Skin? _selectedSkin;
  Skin? _selectedSkinAliat;
  Skin? _selectedSkinEnemic;
  Skin? _selectedSkinQuincy;
  List<Personatge> _personatges = [];
  List<Personatge> _characterEnemies = [];
  List<Skin> _skins = [];
  List<Personatge> _quincys = [];

  List<Personatge> get personatges => _personatges;
  List<Personatge> get characterEnemies => _characterEnemies;
  List<Personatge> get quincys => _quincys;
  List<Skin> get skins => _skins;
  int get coinCount => _coinCount;
  int get coinEnemies => _coinEnemies;
  String get username => _username;
  Skin? get selectedSkin => _selectedSkin;
  Skin? get selectedSkinAliat => _selectedSkinAliat;
  Skin? get selectedSkinEnemic => _selectedSkinEnemic;
  Skin? get selectedSkinQuincy => _selectedSkinQuincy;

  SkinsEnemicsPersonatgesProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt(_userPuntsKey) ?? 0;
    _username = prefs.getString(_userNameKey) ?? 'Usuari';
    notifyListeners();
  }

  bool _combatVideoPlayed = false;

  bool get combatVideoPlayed => _combatVideoPlayed;

  void markCombatVideoAsPlayed() {
    _combatVideoPlayed = true;
    notifyListeners();
  }

  Future<Skin> selectRandomUserSkin() async {
    try {
      // Combinar personatges i quincys
      final allCharacters = [..._personatges, ..._quincys];

      if (allCharacters.isEmpty) {
        throw Exception(
            'No hi ha personatges disponibles (ni aliats ni quincys)');
      }

      // Obtenir totes les skins de tots els personatges
      final allUserSkins = allCharacters.expand((p) => p.skins).toList();

      if (allUserSkins.isEmpty) {
        throw Exception('No hi ha skins disponibles per als aliats o quincys');
      }

      final random = Random();
      final randomSkin = allUserSkins[random.nextInt(allUserSkins.length)];

      _selectedSkinAliat = randomSkin;
      notifyListeners();

      return randomSkin; // Retorna la skin seleccionada
    } catch (e) {
      print('Error al seleccionar skin aleatòria: $e');
      throw e;
    }
  }

  void setSelectedSkinAliat(Skin skin) {
    _selectedSkinAliat = skin;
    _selectedSkinEnemic = null;
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void unselectSkinAliat() {
    _selectedSkinAliat = null;
    notifyListeners();
  }

  void setSelectedSkinQuincy(Skin skin) {
    _selectedSkinQuincy = skin;
    _selectedSkinAliat = null;
    _selectedSkinEnemic = null;
    notifyListeners();
  }

  void unselectSkinQuincy() {
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void setSelectedSkinEnemic(Skin skin) {
    _selectedSkinEnemic = skin;
    _selectedSkinAliat = null;
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void unselectSkinEnemic() {
    _selectedSkinEnemic = null;
    notifyListeners();
  }

  Future<void> selectRandomSkin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final url = Uri.parse('$_baseUrl/skins/enemic/');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey("skin")) {
          final Map<String, dynamic> skinData = data["skin"];
          _selectedSkin = Skin.fromJson(skinData);
          notifyListeners();
        } else {
          print('Error: No s\'ha trobat la clau "skin" en la resposta');
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en selectRandomSkin: $error');
    }
  }

  void updateEnemyHealth(int newHealth) {
    if (_selectedSkin != null) {
      _selectedSkin!.currentHealth = max(newHealth, 0);
      notifyListeners();
    } else {
      print('Error: No s\'ha seleccionat cap skin');
    }
  }

  void updateAllyHealth(int newHealth) {
    if (_selectedSkinAliat != null) {
      _selectedSkinAliat!.currentHealth = max(newHealth, 0);
      notifyListeners();
    } else {
      print('Error: No s\'ha seleccionat cap skin d\'aliat');
    }
  }

  void setMaxEnemyHealth(int maxHealth) {
    _maxEnemyHealth = maxHealth;
    notifyListeners();
  }

  void setMaxAllyHealth(int maxHealth) {
    _maxAllyHealth = maxHealth;
    notifyListeners();
  }

  void resetHealth() {
    if (_selectedSkin != null && _maxEnemyHealth != null) {
      _selectedSkin!.currentHealth = _maxEnemyHealth!;
    }
    if (_selectedSkinAliat != null && _maxAllyHealth != null) {
      _selectedSkinAliat!.currentHealth = _maxAllyHealth!;
    }
    notifyListeners();
  }

  Future<void> fetchEnemyPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || _selectedSkin == null) {
        print("No s'ha trobat cap token o skin seleccionada.");
        return;
      }

      String? skinName = _selectedSkin!.personatgeNom;

      final url = Uri.parse('$_baseUrl/personatges/enemics/$skinName/punts');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': prefs.getString(_userEmailKey)}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('punts_enemic')) {
          _coinEnemies = data['punts_enemic'];
          notifyListeners();
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchEnemyPoints: $error');
    }
  }

 Future<void> fetchPersonatgesAmbSkins(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Obtenir el token

    if (token == null) {
      print("No s'ha trobat cap token. L'usuari no està autenticat.");
      return;
    }

    final url = Uri.parse('$_baseUrl/skins/biblioteca/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      _personatges.clear();
      _skins.clear();

      for (var item in data) {
        final personatge = Personatge.fromJson(item['personatge']);

        bool isAlly = false; // Variable para verificar si alguna skin es de tipo aliado (raça == 1)

        if (item.containsKey('skins') && item['skins'] is List) {
          for (var skinJson in item['skins']) {
            final skin = Skin.fromJson(skinJson);
            personatge.skins.add(skin);

            // Comprobar si la skin es de tipo aliado (raça == 1)
            if (skin.raca == 1) {
              isAlly = true; // Si hay al menos una skin de aliado, marcarlo como aliado
            }
          }
        }

        // Si hay al menos una skin de aliado, añadir el personaje a la lista de personajes aliados
        if (isAlly) {
          _personatges.add(personatge);
        }
      }

      notifyListeners();
    } else {
      print('Error en la resposta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en fetchPersonatgesAmbSkins: $error');
  }
}


  Future<void> fetchEnemicsAmbSkins(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Obtenir el token

    if (token == null) {
      print("No s'ha trobat cap token. L'usuari no està autenticat.");
      return;
    }

    final url = Uri.parse('$_baseUrl/skins/biblioteca/enemics/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      _characterEnemies.clear();
      _skins.clear();

      for (var item in data) {
        final personatge = Personatge.fromJson(item['personatge']);

        bool isEnemic = false;  // Variable para verificar si alguna skin es enemiga

        if (item.containsKey('skins') && item['skins'] is List) {
          for (var skinJson in item['skins']) {
            final skin = Skin.fromJson(skinJson);
            personatge.skins.add(skin);

            // Comprobar si la skin es enemiga (raça == 2)
            if (skin.raca == 2) {
              isEnemic = true; // Si hay al menos una skin enemiga, marcarlo como enemigo
            }
          }
        }

        // Si hay al menos una skin enemiga, añadir el personaje a la lista de enemigos
        if (isEnemic) {
          _characterEnemies.add(personatge);
        }
      }

      notifyListeners();
    } else {
      print('Error en la resposta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en fetchPersonatgesAmbSkins: $error');
  }
}


  Future<void> fetchPersonatgesAmbSkinsQuincys(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final url = Uri.parse('$_baseUrl/skins/biblioteca/quincys/$userId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _quincys.clear();
        _skins.clear();

        for (var item in data) {
          final personatge = Personatge.fromJson(item['personatge']);

          if (item.containsKey('skins') && item['skins'] is List) {
            for (var skinJson in item['skins']) {
              personatge.skins.add(Skin.fromJson(skinJson));
            }
          }

          _quincys.add(personatge);
        }

        notifyListeners();
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchPersonatgesAmbSkins: $error');
    }
  }

  void refreshPoints() {
    fetchEnemyPoints();
  }
}
