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

  int get userId => _userId;
  int get coinCount => _coinCount;
  String get username => _username;
  Personatge? get personatge => _personatge;

  UserProvider() {
    _loadUserData();
  }

  // LOAD ALL USER DATA
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _coinCount = prefs.getInt('userPunts') ?? 0;
    _username = prefs.getString('userName') ?? 'Usuari';
    _userId = prefs.getInt('userId') ?? 0;
    notifyListeners();
    fetchUserPoints();
    fetchFavoritePersonatge();
    updatepersonatgepreferit(personatge);
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

  // FETCH THE USER'S FAVORITE CHARACTER
  Future<void> fetchFavoritePersonatge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || _userId == 0) {
        print('User ID or token missing!');
        return;
      }

      final url = Uri.parse('https://${Config.ip}/preferit/:id');
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          _personatge = Personatge.fromJson(data);
          notifyListeners();
        }
      } else {
        print('Error al obtener el personaje favorito: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en fetchFavoritePersonatge: $error');
    }
  }

  // UPDATE THE USER'S FAVORITE CHARACTER
  Future<void> updatepersonatgepreferit(Personatge? personatge) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || _userId == 0) {
        print(
            'Token o UserID no disponible. No se puede actualizar el personaje preferido.');
        return;
      }

      // Verificamos si el personaje es nulo antes de enviarlo al backend
      if (personatge == null) {
        print('No se ha seleccionado un personaje.');
        return;
      }

      _personatge = personatge;
      notifyListeners();

      final url = Uri.parse('https://${Config.ip}/preferit/update/:id');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode(
          personatge.toJson()); // Convertimos el personaje a formato JSON

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Personaje preferido actualizado correctamente.');
      } else {
        print(
            'Error al actualizar el personaje preferido: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (error) {
      print('Error en updatepersonatgepreferit: $error');
    }
  }
}
