import 'package:hollows_go/models/Arma.dart';

import '../imports.dart';
import 'package:http/http.dart' as http;



class ArmesProvider extends ChangeNotifier {
  List<Arma> _armesDisponibles = [];
  bool _isLoading = false;

  List<Arma> get armesDisponibles => _armesDisponibles;
  bool get isLoading => _isLoading;

  Future<void> fetchArmesPerSkin(int skinId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('https://${Config.ip}/armes/skin/$skinId'));

      if (response.statusCode == 200) {
        final List jsonData = jsonDecode(response.body);
        _armesDisponibles = jsonData.map((a) => Arma.fromJson(a)).toList();
      } else {
        _armesDisponibles = [];
      }
    } catch (e) {
      _armesDisponibles = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> equiparArma({
    required int usuariId,
    required int skinId,
    required int armaId,
  }) async {
    final body = jsonEncode({
      "usuari_id": usuariId,
      "skin_id": skinId,
      "arma_id": armaId,
    });

    final response = await http.post(
      Uri.parse('https://${Config.ip}/armes/equipar'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 200;
  }
}
