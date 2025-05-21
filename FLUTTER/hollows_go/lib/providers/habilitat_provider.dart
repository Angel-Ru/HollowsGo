import '../imports.dart';
import 'package:http/http.dart' as http;

import '../models/habilitat_llegendaria.dart';

class HabilitatProvider with ChangeNotifier {
  HabilitatLlegendaria? _habilitat;

  HabilitatLlegendaria? get habilitat => _habilitat;

  Future<void> loadHabilitatPerSkinId(int skinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/habilitats/$skinId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          // Según el error que te salió, data puede ser List o Map, si es List cogemos el primer elemento
          if (data is List && data.isNotEmpty) {
            _habilitat = HabilitatLlegendaria.fromJson(data[0]);
          } else if (data is Map<String, dynamic>) {
            _habilitat = HabilitatLlegendaria.fromJson(data);
          } else {
            _habilitat = null;
          }
        } else {
          _habilitat = null;
        }
      } else if (response.statusCode == 404) {
        _habilitat = null;
      } else {
        throw Exception(
            'Error inesperat carregant habilitat: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error carregant habilitat: $e');
      _habilitat = null;
    }

    notifyListeners();
  }

  Future<void> loadHabilitatPerPersonatgeId(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token no disponible');
      }

      final url = Uri.parse('https://${Config.ip}/habilitats/personatge/$id');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _habilitat = HabilitatLlegendaria.fromJson(data);
      } else if (response.statusCode == 404) {
        _habilitat = null; // Personatge sense habilitat llegendària
      } else {
        throw Exception('Error carregant habilitat: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error carregant habilitat: $e');
      _habilitat = null;
    }

    notifyListeners();
  }

  void clearHabilitat() {
    _habilitat = null;
    notifyListeners();
  }
}
