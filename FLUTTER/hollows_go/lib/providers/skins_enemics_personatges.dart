import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hollows_go/models/personatge.dart'; // Importa el model Personatge
import 'package:hollows_go/models/skin.dart'; // Importa el model Skin

class SkinsEnemicsPersonatgesProvider with ChangeNotifier {
  // Constants per a URLs i claus de SharedPreferences
  static const String _baseUrl = 'http://192.168.2.197:3000';
  static const String _userPuntsKey = 'userPunts';
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';

  int _coinCount = 0; // Punts de l'usuari
  int _coinEnemies = 0; // Punts de l'enemic
  String _username = 'Usuari';
  Skin? _selectedSkin; // Skin seleccionada
  Skin? _selectedSkinAliat;
  List<Personatge> _personatges = []; // Llista de personatges
  List<Personatge> _characterEnemies = []; // Llista de personatges enemics
  List<Skin> _skins = []; // Llista de skins

  // Getters
  List<Personatge> get personatges => _personatges;
  List<Personatge> get characterEnemies => _characterEnemies;
  List<Skin> get skins => _skins;
  int get coinCount => _coinCount;
  int get coinEnemies => _coinEnemies;
  String get username => _username;
  Skin? get selectedSkin => _selectedSkin;
  Skin? get selectedSkinAliat => _selectedSkinAliat;

  SkinsEnemicsPersonatgesProvider() {
    _loadUserData();
  }

  // Carregar dades locals
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt(_userPuntsKey) ?? 0;
    _username = prefs.getString(_userNameKey) ?? 'Usuari';
    notifyListeners();
  }

  void setSelectedSkinAliat(Skin skin) {
    _selectedSkinAliat = skin;
    notifyListeners();
  }

  // Seleccionar una skin aleatòria
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
          'Authorization': 'Bearer $token', // Incloure el token
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Extreure l'objecte "skin" del JSON
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
      _selectedSkin!.currentHealth = max(newHealth, 0); // Assegura que la salut no sigui negativa
      notifyListeners();
    } else {
      print('Error: No s\'ha seleccionat cap skin');
    }
  }

  void updateAllyHealth(int newHealth) {
    if (_selectedSkinAliat != null) {
      _selectedSkinAliat!.currentHealth = max(newHealth, 0); // Assegura que la salut no sigui negativa
      notifyListeners();
    } else {
      print('Error: No s\'ha seleccionat cap skin d\'aliat');
    }
  }

  // Obtenir els punts de l'enemic basant-se en la skin seleccionada
  Future<void> fetchEnemyPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null || _selectedSkin == null) {
        print("No s'ha trobat cap token o skin seleccionada.");
        return;
      }

      // Obtenir el nom de la skin seleccionada
      String? skinName = _selectedSkin!.personatgeNom;

      final url = Uri.parse('$_baseUrl/personatges/enemics/$skinName/punts');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Incloure el token
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

  // Obtenir personatges amb les seves skins
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
          'Authorization': 'Bearer $token', // Incloure el token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Netegem les llistes abans d'afegir noves dades
        _personatges.clear();
        _skins.clear();

        for (var item in data) {
          // Creem el personatge
          final personatge = Personatge.fromJson(item['personatge']);

          // Afegim les skins del personatge
          if (item.containsKey('skins') && item['skins'] is List) {
            for (var skinJson in item['skins']) {
              personatge.skins.add(Skin.fromJson(skinJson));
            }
          }

          // Afegim el personatge a la llista
          _personatges.add(personatge);
        }

        notifyListeners();
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchPersonatgesAmbSkins: $error');
    }
  }

  // Carregar personatges enemics amb les seves skins
  Future<void> fetchPersonatgesEnemicsAmbSkins() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // Obtenir el token

      if (token == null) {
        print("No s'ha trobat cap token. L'usuari no està autenticat.");
        return;
      }

      final url = Uri.parse('$_baseUrl/skins/enemic/personatges');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Incloure el token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        _characterEnemies.clear();

        for (var item in data) {
          final personatge = Personatge.fromJson(item['personatge']);

          if (item.containsKey('skins') && item['skins'] is List) {
            for (var skinJson in item['skins']) {
              personatge.skins.add(Skin.fromJson(skinJson));
            }
          }

          _characterEnemies.add(personatge);
        }

        notifyListeners();
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchPersonatgesEnemicsAmbSkins: $error');
    }
  }

  // Forçar l'actualització de punts manualment
  void refreshPoints() {
    fetchEnemyPoints();
  }
}