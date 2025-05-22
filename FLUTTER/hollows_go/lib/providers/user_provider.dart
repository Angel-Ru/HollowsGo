import 'package:http/http.dart' as http;
import '../imports.dart';

/*
Aquesta classe és un provider que conté la informació de l'usuari.
Aquesta informació es pot actualitzar amb el mètode fetchUserPoints.
Aquest mètode fa una petició a l'API per obtenir els punts de l'usuari.
S'ha de canviar l'IP del servidor per a que funcioni correctament.
*/

class UserProvider with ChangeNotifier {
  int _coinCount = 0;
  String _username = 'Usuari';
  int _userId = 0;
  Personatge? _personatge;
  int? _personatgePreferitId;
  int? _skinPreferidaId;
  String? _personatgepreferitnom;
  String? _skinPreferidaimatge;

  int get userId => _userId;
  int get coinCount => _coinCount;
  String get username => _username;
  Personatge? get personatge => _personatge;
  int? get personatgePreferitId => _personatgePreferitId;
  int? get skinPreferidaId => _skinPreferidaId;
  String? get personatgepreferitnom => _personatgepreferitnom;
  String? get skinPreferidaimatge => _skinPreferidaimatge;

  UserProvider() {
    _loadUserData();
  }

  get skinPreferidaNom => null;

  // LOAD ALL USER DATA
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt('userPunts') ?? 0;
    _username = prefs.getString('userName') ?? 'Usuari';
    _userId = prefs.getInt('userId') ?? 0;
    notifyListeners();
    fetchUserPoints();
    fetchFavoritePersonatgeSkin();
  }

  // GET USER COINS OR POINTS FROM THE API
  Future<void> fetchUserPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nomUsuari = prefs.getString('userName');
      String? token = prefs.getString('token');

      if (nomUsuari == null || token == null) return;

      final url = Uri.parse('https://${Config.ip}/usuaris/punts/$nomUsuari');
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          int newCoinCount = data[0]['punts_emmagatzemats'];
          _username = data[0]['nom'];
          _coinCount = newCoinCount;
          await prefs.setInt('userPunts', newCoinCount);
          await prefs.setString('userName', _username);
          notifyListeners();
        }
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error a fetchUserPoints: $error');
    }
  }

  // REFERESH THE AMOUNT OF POINTS THAT THE USER HAS
  void refreshPoints() {
    fetchUserPoints();
  }

  Future<void> fetchFavoritePersonatgeSkin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId == null || token == null) return;

      final url = Uri.parse('https://${Config.ip}/perfils/preferit/$userId');
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Actualizar ambos valores (personaje y skin preferidos)
        _personatgePreferitId = data['personatge_preferit'] ?? 0;
        _skinPreferidaId = data['skin_preferida_id'] ?? 0;
        _personatgepreferitnom = data['nom'];
        _skinPreferidaimatge = data['imatge'];

        print('Personaje favorito actualizado: $_personatgePreferitId');
        print('Skin favorita actualizada: $_skinPreferidaId');

        notifyListeners();
      } else {
        print('Error en fetchFavoritePersonatge: ${response.statusCode}');
        // Opcional: resetear valores si hay error
        _personatgePreferitId = 0;
        _skinPreferidaId = 0;
        notifyListeners();
      }
    } catch (error) {
      print('Error en fetchFavoritePersonatge: $error');
      // Opcional: resetear valores si hay excepción
      _personatgePreferitId = 0;
      _skinPreferidaId = 0;
      notifyListeners();
    }
  }

  Future<bool> updatePersonatgePreferit(int personatgeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId == null || token == null) return false;

      final url =
          Uri.parse('https://${Config.ip}/perfils/preferit/update/$userId');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'personatge_preferit': personatgeId,
      });

      final response = await http.put(url, headers: headers, body: body);
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        _personatgePreferitId = personatgeId;
        print(_personatgePreferitId);
        notifyListeners();
        return true;
      } else {
        print(
            'Error en updatePersonatgePreferit: ${response.statusCode} + ${response}');
        return false;
      }
    } catch (error) {
      print('Error en updatePersonatgePreferit: $error');
      return false;
    }
  }

  Future<bool> updateSkinPreferida(int skinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId == null || token == null) return false;

      final url = Uri.parse('https://${Config.ip}/perfils/skin/update/$userId');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'skin_preferida_id': skinId,
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        _skinPreferidaId = skinId;
        print(_skinPreferidaId);
        notifyListeners();
        return true;
      } else {
        print(
            'Error en updateSkinPreferida: ${response.statusCode} + ${response}');
        return false;
      }
    } catch (error) {
      print('Error en updateSkinPreferida: $error');
      return false;
    }
  }

  Future<void> sumarExperiencia(String nomEnemic) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nomUsuari = prefs.getString('userName');
      String? token = prefs.getString('token');

      if (nomUsuari == null || token == null) return;

      final url = Uri.parse('https://${Config.ip}/sumar_exp/$nomUsuari');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({'nom': nomEnemic}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int puntsSumats = data['punts_sumats'];
        print('Experiència sumada: $puntsSumats');
      } else {
        print('Error en la resposta: ${response.statusCode}');
      }
    } catch (error) {
      print('Error a sumarExperiencia: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAmistatsUsuari() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('userId');
      String? token = prefs.getString('token');

      if (userId == null || token == null) return [];

      final url = Uri.parse('https://${Config.ip}/usuaris/amics/$userId');
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Conversió segura a llista de mapes
        final List<Map<String, dynamic>> amistats = data.map((amic) {
          return {
            'nom_amic': amic['nom_amic'],
            'estat': amic['estat'],
          };
        }).toList();

        return amistats;
      } else {
        print('Error en fetchAmistatsUsuari: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error a fetchAmistatsUsuari: $error');
      return [];
    }
  }

  Future<bool> acceptarAmistat(int userId, int amistatId, String token) async {
    try {
      final url =
          Uri.parse('https://${Config.ip}/usuaris/amics/$userId/acceptar');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final body = json.encode({'amistat_id': amistatId});

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error acceptant amistat: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error a acceptarAmistat: $e');
      return false;
    }
  }
}
