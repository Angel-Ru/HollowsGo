import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/missionArma.dart';
import '../models/missionDiaria.dart';
import '../models/missionTitol.dart';

class MissionsProvider with ChangeNotifier {
  List<MissionDiary> _missions = [];

  List<MissionDiary> get missions => _missions;

  MissionTitol? _missioTitol;
  MissionTitol? get missioTitol => _missioTitol;

  MissionArma? _missioArma;
  MissionArma? get missioArma => _missioArma;

  Future<void> fetchMissions(int usuariId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('https://${Config.ip}/missions/diaries/$usuariId');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List missionsJson = data['missions'] ?? [];
      _missions =
          missionsJson.map((json) => MissionDiary.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Error carregant missions');
    }
  }

  Future<void> incrementProgress(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url =
        Uri.parse('https://${Config.ip}/missions/progres/incrementa/$id');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Error incrementant progrés');
    }
  }

  Future<void> assignarMissionsTitols(int usuariId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('https://${Config.ip}/missions/titols/$usuariId');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error assignant missions de títol');
    }
  }

  Future<void> fetchMissioTitol(int usuariId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('https://${Config.ip}/missions/titol/$usuariId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _missioTitol = MissionTitol.fromJson(data);
      notifyListeners();
    } else {
      throw Exception('Error carregant missió de títol');
    }
  }
  Future<void> incrementarProgresMissioTitol(int missioId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final url = Uri.parse('https://${Config.ip}/missions/titol/progres/incrementa/$missioId');

  final response = await http.patch(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Opcional: pots tornar a cridar fetchMissioTitol per refrescar dades
    notifyListeners();
  } else {
    throw Exception('Error incrementant progrés de la missió de títol');
  }
}

Future<void> fetchMissioArma(int usuariId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final url = Uri.parse('https://${Config.ip}/missions/arma/$usuariId');

  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data.containsKey('missio')) {
      // Tenim la missió dins 'missio'
      _missioArma = MissionArma.fromJson(data['missio']);
    } else {
      
      _missioArma = null;
      debugPrint('Missió arma no disponible: ${data['missatge']}');
    }

    notifyListeners();
  } else {
    throw Exception('Error carregant missió d\'arma');
  }
}

Future<void> incrementarProgresMissioArma(int usuariId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final url = Uri.parse('https://${Config.ip}/missions/arma/progres/incrementa/$usuariId');

  final response = await http.patch(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
   
    fetchMissioArma(usuariId);
    notifyListeners();
  } else {
    throw Exception('Error incrementant progrés de la missió d\'arma');
  }
}


}
