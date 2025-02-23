import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hollows_go/models/skin.dart'; // Importa el model Skin

class Skins_Enemics_Personatges_Provider with ChangeNotifier {
  int _coinCount = 0; // Punts de l'usuari
  int _coinEnemies = 0; // Punts de l'enemic
  String _username = 'Usuari';
  SkinClass? _selectedSkin; // Skin seleccionada (utilitzant el model)

  int get coinCount => _coinCount;
  int get coinEnemies => _coinEnemies; // Getter per als punts de l'enemic
  String get username => _username;
  SkinClass? get selectedSkin =>
      _selectedSkin; // Getter per a la skin seleccionada

  Skins_Enemics_Personatges_Provider() {
    _loadUserData();
  }

  // Carregar dades locals i després obtenir les actualitzades de l'API
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt('userPunts') ?? 0;
    _username = prefs.getString('userName') ?? 'Usuari';
    notifyListeners();
  }

  // Seleccionar una skin aleatòria
  Future<void> selectRandomSkin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userEmail = prefs.getString('userEmail');

      if (userEmail == null) return;

      final url = Uri.parse('http://192.168.1.28:3000/skins/enemic/');
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Skin skin = skinFromJson(response.body);

        _selectedSkin = skin.skin;
        notifyListeners();
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en selectRandomSkin: $error');
    }
  }

  void updateEnemyHealth(int newHealth) {
    if (selectedSkin != null) {
      // Comprovar si l'enemic canviat té una nova skin
      selectedSkin!.currentHealth =
          max(newHealth, 0); // S'assegura que la salut no sigui negativa
      notifyListeners();
    }
  }

  // Obtenir els punts de l'enemic basant-se en la skin seleccionada
  Future<void> fetchEnemyPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userEmail =
          prefs.getString('userEmail'); // Obtenir el correu guardat

      if (userEmail == null || _selectedSkin == null)
        return; // Si no hi ha correu o skin seleccionada, no fem res

      // Obtenir el nom de la skin seleccionada
      String skinName = _selectedSkin!.personatgeNom;

      // Endpoint per obtenir els punts de l'enemic basant-se en la skin seleccionada
      final url = Uri.parse(
          'http://192.168.1.28:3000/personatges/enemics/$skinName/punts');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': userEmail}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('punts_enemic')) {
          // Actualitza els punts de l'enemic
          _coinEnemies = data['punts_enemic'];
          notifyListeners(); // Notifica als listeners que els punts han canviat
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchEnemyPoints: $error');
    }
  }

  // Forçar l'actualització de punts manualment
  void refreshPoints() {
    fetchEnemyPoints();
  }
}
