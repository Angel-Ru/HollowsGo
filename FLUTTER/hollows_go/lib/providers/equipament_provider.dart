import 'package:hollows_go/models/Arma.dart';
import '../imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArmesProvider extends ChangeNotifier {
  List<Arma> _armesDisponibles = [];
  bool _isLoading = false;

  List<Arma> get armesDisponibles => _armesDisponibles;
  bool get isLoading => _isLoading;

  Future<void> fetchArmesPerSkin(int skinId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        _armesDisponibles = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/armes/skin/$skinId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        _armesDisponibles = jsonData.map((a) => Arma.fromJson(a)).toList();
      } else {
        _armesDisponibles = [];
        print('Error carregant armes: ${response.statusCode}');
      }
    } catch (e) {
      _armesDisponibles = [];
      print('Error a fetchArmesPerSkin: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> equiparArma({
    required int usuariId,
    required int skinId,
    required int armaId,
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
        "arma_id": armaId,
      });

      final response = await http.post(
        Uri.parse('https://${Config.ip}/armes/equipar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error equipant arma: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error a equiparArma: $e');
      return false;
    }
  }
}
