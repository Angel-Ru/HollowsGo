import 'package:hollows_go/models/Arma.dart';
import '../imports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArmesProvider extends ChangeNotifier {
  List<Arma> _armesDisponibles = [];
  Arma? _armaEquipada;
  bool _isLoading = false;

  List<Arma> get armesDisponibles => _armesDisponibles;
  Arma? get armaEquipada => _armaEquipada;
  bool get isLoading => _isLoading;

  Future<void> fetchArmesPerSkin(int skinId, int usuariId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        _armesDisponibles = [];
        _armaEquipada = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/equipaments/skins/$skinId/armes/$usuariId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List armesJson = jsonData['armesPredefinides'] ?? [];
        _armesDisponibles = armesJson.map((a) => Arma.fromJson(a)).toList();

        final armaEquipadaJson = jsonData['armaEquipada'];
        _armaEquipada = armaEquipadaJson != null ? Arma.fromJson(armaEquipadaJson) : null;
      } else {
        _armesDisponibles = [];
        _armaEquipada = null;
        print('Error carregant armes: ${response.statusCode}');
      }
    } catch (e) {
      _armesDisponibles = [];
      _armaEquipada = null;
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
        Uri.parse('https://${Config.ip}/equipaments/equipament'),
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
