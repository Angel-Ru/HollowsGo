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
  int? _userId;

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
    _userId = prefs.getInt('userId');
    notifyListeners();
  }

  bool _combatVideoPlayed = false;

  bool get combatVideoPlayed => _combatVideoPlayed;

  void markCombatVideoAsPlayed() {
    _combatVideoPlayed = true;
    notifyListeners();
  }

  Future<void> selectRandomUserSkinAliat() async {
    if (_personatges.isEmpty) return;
    final allSkins = _personatges.expand((p) => p.skins).toList();
    if (allSkins.isEmpty) return;
    final random = Random();
    _selectedSkinAliat = allSkins[random.nextInt(allSkins.length)];
    _selectedSkinEnemic = null; // Assegurem que no hi ha skin enemic seleccionada
    _selectedSkinQuincy = null; // Assegurem que no hi ha skin quincy seleccionada
    actualitzarSkinSeleccionada(_userId!, _selectedSkinAliat!.id);
    notifyListeners();
  }

  Future<void> selectRandomUserSkinQuincy() async {
    if (_quincys.isEmpty) return;
    final allSkins = _quincys.expand((p) => p.skins).toList();
    if (allSkins.isEmpty) return;
    final random = Random();
    _selectedSkinQuincy = allSkins[random.nextInt(allSkins.length)];
    _selectedSkinEnemic = null; // Assegurem que no hi ha skin enemic seleccionada
    _selectedSkinAliat = null; // Assegurem que no hi ha skin aliada seleccionada
    actualitzarSkinSeleccionada(_userId!, _selectedSkinQuincy!.id);
    notifyListeners();
  }

  Future<void> selectRandomUserSkinEnemic() async {
    if (_characterEnemies.isEmpty) return;
    final allSkins = _characterEnemies.expand((p) => p.skins).toList();
    if (allSkins.isEmpty) return;
    final random = Random();
    _selectedSkinEnemic = allSkins[random.nextInt(allSkins.length)];
    _selectedSkinAliat = null; // Assegurem que no hi ha skin aliada seleccionada
    _selectedSkinQuincy = null; // Assegurem que no hi ha skin quincy seleccionada
    actualitzarSkinSeleccionada(_userId!, _selectedSkinEnemic!.id);
    notifyListeners();
  }

  void setSelectedSkinAliat(Skin? skin) {
    _selectedSkinAliat = skin;
    _selectedSkinEnemic = null;
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void unselectSkinAliat() {
    _selectedSkinAliat = null;
    notifyListeners();
  }

  void setSelectedSkinQuincy(Skin? skin) {
    _selectedSkinQuincy = skin;
    _selectedSkinAliat = null;
    _selectedSkinEnemic = null;
    notifyListeners();
  }

  void unselectSkinQuincy() {
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void setSelectedSkinEnemic(Skin? skin) {
    _selectedSkinEnemic = skin;
    _selectedSkinAliat = null;
    _selectedSkinQuincy = null;
    notifyListeners();
  }

  void unselectSkinEnemic() {
    _selectedSkinEnemic = null;
    notifyListeners();
  }

  // Metode que selecciona s'enemic de forma random
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
    String? token = prefs.getString('token');

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

      // Sempre netejar les llistes abans d’afegir
      _personatges.clear();
      _skins.clear();

      for (var item in data) {
        final personatge = Personatge.fromJson(item['personatge']);

        bool isAlly = false;

        if (item.containsKey('skins') && item['skins'] is List) {
          for (var skinJson in item['skins']) {
            final skin = Skin.fromJson(skinJson);
            personatge.skins.add(skin);

            if (skin.raca == 1) {
              isAlly = true;
            }
          }
        }

        if (isAlly) {
          _personatges.add(personatge);
        }
      }

      notifyListeners();
    } else if (response.statusCode == 404) {
      print('No s\'han trobat personatges amb skins.');

      // Buidar explícitament les llistes
      _personatges.clear();
      _skins.clear();

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
    String? token = prefs.getString('token');

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

        bool isEnemic = false;

        if (item.containsKey('skins') && item['skins'] is List) {
          for (var skinJson in item['skins']) {
            final skin = Skin.fromJson(skinJson);
            personatge.skins.add(skin);

            if (skin.raca == 2) {
              isEnemic = true;
            }
          }
        }

        if (isEnemic) {
          _characterEnemies.add(personatge);
        }
      }

      notifyListeners();
    } else if (response.statusCode == 404) {
      print('No s\'han trobat enemics amb skins.');

      // Buidar explícitament la llista d’enemics
      _characterEnemies.clear();
      _skins.clear();

      notifyListeners();
    } else {
      print('Error en la resposta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en fetchEnemicsAmbSkins: $error');
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
    } else if (response.statusCode == 404) {
      print('No s\'han trobat quincys amb skins.');

      // Netejar les llistes
      _quincys.clear();
      _skins.clear();

      notifyListeners();
    } else {
      print('Error en la resposta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en fetchPersonatgesAmbSkinsQuincys: $error');
  }
}


  void refreshPoints() {
    fetchEnemyPoints();
  }

  Future<Personatge?> fetchPersonatgeById(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return null;
      }

      final url = Uri.parse('$_baseUrl/personatges/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          final personatge = Personatge.fromJson(data[0]);
          return personatge;
        } else {
          print("No s'ha trobat cap personatge amb l'ID proporcionat.");
          return null;
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error en fetchPersonatgeById: $error');
      return null;
    }
  }

  Future<List<Skin>?> fetchPersonatgeSkins(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return null;
      }

      final url = Uri.parse('$_baseUrl/skins/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Si la respuesta es un mensaje de texto (cuando no hay skins)
        if (responseBody is String &&
            responseBody.contains("No s'han trobat skins")) {
          return [];
        }

        final List<dynamic> data = json.decode(responseBody);
        final List<Skin> skins = [];

        for (var skinJson in data) {
          final skin = Skin.fromJson(skinJson);
          skins.add(skin);
        }

        return skins;
      } else {
        print('Error en la resposta: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error en fetchPersonatgeSkins: $error');
      return null;
    }
  }

  Future<void> getSkinSeleccionada(int id) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No s'ha trobat cap token. L'usuari no està autenticat.");
      return;
    }

    final url = Uri.parse('$_baseUrl/skins/seleccionada/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('skin')) {
        final skin = Skin.fromJson(data['skin']);

        // Assignar-la segons la categoria
        switch (skin.raca) {
          case 0:
            setSelectedSkinQuincy(skin);
            break;
          case 1:
            setSelectedSkinAliat(skin);
            break;
          case 2:
            setSelectedSkinEnemic(skin);
            break;
        }

        notifyListeners(); // <- Important per actualitzar la UI
      } else {
        print('No s\'ha trobat cap skin seleccionada al JSON.');
      }
    } else if (response.statusCode == 404) {
      print('No hi ha cap skin seleccionada.');

      // Quan no hi ha skin seleccionada, posar-les totes a null
      setSelectedSkinQuincy(null);
      setSelectedSkinAliat(null);
      setSelectedSkinEnemic(null);

      notifyListeners(); // <- Important per actualitzar la UI
    } else {
      print('Error en la resposta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error a getSkinSeleccionada: $error');
  }
}


  Future<void> actualitzarSkinSeleccionada(int userId, int skinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final url = Uri.parse('$_baseUrl/skins/seleccionada/actuliatzar/$userId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'skin': skinId}),
      );

      if (response.statusCode == 200) {
        print('Skin seleccionada actualitzada correctament.');

        // Un cop actualitzada, pots refrescar la selecció actual:
        await getSkinSeleccionada(userId);
      } else if (response.statusCode == 404) {
        print('No s’ha trobat la skin per a aquest usuari.');
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error a actualitzarSkinSeleccionada: $error');
    }
  }

  Future<void> llevarkinSeleccionada(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final url = Uri.parse('$_baseUrl/skins/seleccionada/llevar/$userId');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Skin seleccionada llevada correctament.');

        await getSkinSeleccionada(userId);

        //Aixo es lo nou que he afegit per desseleccionar, els metodes ja estaven pero no se cridaven per tant a nivell local no es deselectaven
        unselectSkinAliat();
        unselectSkinQuincy();
        unselectSkinEnemic();
      } else if (response.statusCode == 404) {
        print('No s’ha trobat la skin per a aquest usuari.');
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error a actualitzarSkinSeleccionada: $error');
    }
  }
}
