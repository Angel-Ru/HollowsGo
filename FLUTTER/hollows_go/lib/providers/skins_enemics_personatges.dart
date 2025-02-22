import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Skins_Enemics_Personatges_Provider with ChangeNotifier {
  int _coinCount = 0; // Punts de l'usuari
  int _coinEnemies = 0; // Punts de l'enemic
  String _username = 'Usuari';

  int get coinCount => _coinCount;
  int get coinEnemies => _coinEnemies; // Getter per als punts de l'enemic
  String get username => _username;

  Skins_Enemics_Personatges_Provider() {
    _loadUserData();
  }

  // Cargar datos locales y luego obtener los actualizados de la API
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt('userPunts') ?? 0;
    _username = prefs.getString('userName') ?? 'Usuari';
    notifyListeners();
    fetchUserPoints(); // Después de cargar localmente, sincroniza con la API
  }

  // Obtener puntos desde la API
 Future<void> fetchUserPoints() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail'); // Obtener el correo guardado

    if (userEmail == null) return; // Si no hay correo, no hacemos nada

    // Endpoint para obtener los puntos del enemigo
    final url = Uri.parse('http://192.168.2.197:3000/personatges/enemics/Aizen/punts');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': userEmail}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('punts_enemic')) {
        int puntsEnemic = data['punts_enemic']; // Punts de l'enemic
        _coinEnemies = puntsEnemic; // Desa els punts de l'enemic
        notifyListeners(); // Notifica als listeners que els punts han canviat
      }
    } else {
      print('Error en la respuesta: ${response.statusCode}');
    }
  } catch (error) {
    print('Error en fetchUserPoints: $error');
  }
}

  // Forzar la actualización de puntos manualmente
  void refreshPoints() {
    fetchUserPoints();
  }
}