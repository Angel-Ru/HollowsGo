import '../imports.dart';
import 'package:http/http.dart' as http;

class PersonatgesProvider with ChangeNotifier {
  static const String _baseUrl = 'https://${Config.ip}';

  Personatge? _currentPersonatge;
  bool _isLoading = false;
  String? _errorMessage;

  Personatge? get currentPersonatge => _currentPersonatge;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPersonatgeById(int id) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception(
            "No s'ha trobat cap token. L'usuari no està autenticat.");
      }

      final url = Uri.parse('$_baseUrl/personatges/$id');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          _currentPersonatge = Personatge.fromJson(data[0]);
        } else {
          throw Exception('No s\'ha trobat cap personatge amb aquest ID');
        }
      } else {
        throw Exception('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      _errorMessage = error.toString();
      print('Error en fetchPersonatgeById: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCurrentPersonatge() {
    _currentPersonatge = null;
    notifyListeners();
  }
}
