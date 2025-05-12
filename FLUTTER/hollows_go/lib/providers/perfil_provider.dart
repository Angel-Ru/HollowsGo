import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';

class PerfilProvider with ChangeNotifier {
  int _partidesJugades = 0;
  int _partidesGuanyades = 0;
  int _nombrePersonatges = 0;
  int _nombreSkins = 0;

  int get partidesJugades => _partidesJugades;
  int get partidesGuanyades => _partidesGuanyades;
  int get nombrePersonatges => _nombrePersonatges;
  int get nombreSkins => _nombreSkins;

  Future<void> fetchPerfilData(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/usuaris/perfil/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _partidesJugades = int.tryParse(data['partides_jugades'].toString()) ?? 0;
        _partidesGuanyades =int.tryParse(data['partides_guanyades'].toString()) ?? 0;
        _nombrePersonatges = data['nombre_personatges'] ?? 0;
        _nombreSkins = int.tryParse(data['nombre_skins'].toString()) ?? 0;

        notifyListeners();
      } else {
        print('Error carregant dades del perfil: ${response.body}');
      }
    } catch (e) {
      print('Error a fetchPerfilData: $e');
    }
  }
  Future<void> sumarPartidaJugada(int userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token no disponible a SharedPreferences");
      return;
    }

    final response = await http.put(
      Uri.parse('https://${Config.ip}/usuaris/partida_jugada/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _partidesJugades += 1;
      notifyListeners();
    } else {
      print('Error sumant partida jugada: ${response.body}');
    }
  } catch (e) {
    print('Error a sumarPartidaJugada: $e');
  }
}

Future<void> sumarPartidaGuanyada(int userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token no disponible a SharedPreferences");
      return;
    }

    final response = await http.put(
      Uri.parse('https://${Config.ip}/usuaris/partida_guanyada/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _partidesGuanyades += 1;
      notifyListeners();
    } else {
      print('Error sumant partida guanyada: ${response.body}');
    }
  } catch (e) {
    print('Error a sumarPartidaGuanyada: $e');
  }
}

}
