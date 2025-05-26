import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/missionDiaria.dart';

class MissionsProvider with ChangeNotifier {
  List<MissionDiary> _missions = [];

  List<MissionDiary> get missions => _missions;

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
      _missions = missionsJson.map((json) => MissionDiary.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Error carregant missions');
    }
  }

  Future<void> updateProgress(int id, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('https://${Config.ip}/missions/progres/$id');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'progress': progress}),
    );

    if (response.statusCode == 200) {
      // Actualitza localment
      final index = _missions.indexWhere((m) => m.id == id);
      if (index != -1) {
        _missions[index] = MissionDiary(
          id: _missions[index].id,
          usuari: _missions[index].usuari,
          missio: _missions[index].missio,
          dataAssign: _missions[index].dataAssign,
          nom: _missions[index].nom,
          descripcio: _missions[index].descripcio,
          progress: progress,
          objectiu: _missions[index].objectiu,
        );
        notifyListeners();
      }
    } else {
      throw Exception('Error actualitzant progrés');
    }
  }
}
