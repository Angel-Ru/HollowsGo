// lib/providers/perfil_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../imports.dart';

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
      final response = await http.get(Uri.parse('https://${Config.ip}/usuaris/perfil/$userId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _partidesJugades = data['partides_jugades'] ?? 0;
        _partidesGuanyades = data['partides_guanyades'] ?? 0;
        _nombrePersonatges = data['nombre_personatges'] ?? 0;
        _nombreSkins = data['nombre_skins'] ?? 0;
        notifyListeners();
      } else {
        throw Exception('Error carregant dades del perfil');
      }
    } catch (e) {
      print('Error al obtenir dades del perfil: $e');
    }
  }
}
