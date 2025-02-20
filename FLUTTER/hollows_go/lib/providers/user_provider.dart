import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  int _coinCount = 0;
  String _username = 'Usuari';

  int get coinCount => _coinCount;
  String get username => _username;

  UserProvider() {
    _loadUserData();
  }

  // Carregar dades locals i després obtenir les actualitzades de l'API
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt('userPunts') ?? 0;
    _username = prefs.getString('userName') ?? 'Usuari';
    notifyListeners();
    fetchUserPoints(); // Després de carregar localment, sincronitza amb l'API
  }

  // Obtenir punts des de l'API
  Future<void> fetchUserPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nomUsuari = prefs.getString('userName'); // Obtenir el nom guardat

      if (nomUsuari == null) return; // Si no hi ha usuari, no fem res

      final url = Uri.parse('http://192.168.228.168:3000/usuaris/punts/$nomUsuari');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        if (data.isNotEmpty) {
          int newCoinCount = data[0]['punts_emmagatzemats'];
          _coinCount = newCoinCount;
          await prefs.setInt('userPunts', newCoinCount);
          notifyListeners();
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error a fetchUserPoints: $error');
    }
  }

  // Forçar l'actualització de punts manualment
  void refreshPoints() {
    fetchUserPoints();
  }
}
