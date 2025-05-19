import 'package:http/http.dart' as http;
import '../imports.dart';

class VialsProvider extends ChangeNotifier {
  int _vials = 0;
  bool _isLoading = false;

  int get vials => _vials;
  bool get isLoading => _isLoading;

  Future<void> fetchVials(int usuariId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        _vials = 0;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/equipaments/vials/$usuariId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _vials = data['vials'] ?? 0;
      } else {
        print('Error carregant vials: ${response.statusCode}');
        _vials = 0;
      }
    } catch (e) {
      print('Error a fetchVials: $e');
      _vials = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Retorna true si el vial s’ha utilitzat correctament
  Future<bool> utilitzarVial({
    required int usuariId,
    required int skinId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return false;
      }

      final body = jsonEncode({
        "usuari_id": usuariId,
        "skin_id": skinId,
      });

      final response = await http.post(
        Uri.parse('https://${Config.ip}/equipaments/vials/utilitzar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _vials = data['vialsRestants'] ?? _vials - 1; // fallback
        notifyListeners();
        return true;
      } else {
        print('Error utilitzant vial: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error a utilitzarVial: $e');
      return false;
    }
  }
}
