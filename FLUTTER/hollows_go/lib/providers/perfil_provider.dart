import 'package:hollows_go/models/titol.dart';
import 'package:http/http.dart' as http;
import '../imports.dart';

class PerfilProvider with ChangeNotifier {
  int _partidesJugades = 0;
  int _partidesGuanyades = 0;
  int _nombrePersonatges = 0;
  int _nombreSkins = 0;

  int get partidesJugades => _partidesJugades;
  int get partidesGuanyades => _partidesGuanyades;
  int get nombrePersonatges => _nombrePersonatges;
  int get nombreSkins => _nombreSkins;

  Titol? _titolUsuari;
  Titol? get titolUsuari => _titolUsuari;

  Future<void> fetchPerfilData(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/usuaris/perfil/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        print("Resposta del servidor: $body");

        if (body.isEmpty) {
          print("El body està buit. Assignant valors per defecte.");
          _partidesJugades = 0;
          _partidesGuanyades = 0;
          _nombrePersonatges = 0;
          _nombreSkins = 0;
        } else {
          final data = json.decode(body);

          _partidesJugades =
              int.tryParse(data['partides_jugades']?.toString() ?? '0') ?? 0;
          _partidesGuanyades =
              int.tryParse(data['partides_guanyades']?.toString() ?? '0') ?? 0;
          _nombrePersonatges =
              int.tryParse(data['nombre_personatges']?.toString() ?? '0') ?? 0;
          _nombreSkins =
              int.tryParse(data['nombre_skins']?.toString() ?? '0') ?? 0;
        }

        notifyListeners();
      } else {
        print('Error carregant dades del perfil: ${response.body}');
      }
    } catch (e) {
      print('Error a fetchPerfilData: $e');
    }
  }

  Future<void> sumarPartidaJugada(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return;
      }

      final response = await http.put(
        Uri.parse('https://${Config.ip}/usuaris/partida_jugada/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _partidesJugades += 1;
        notifyListeners();
      } else {
        print('Error sumant partida jugada: ${response.body}');
      }
    } catch (e) {
      print('Error a sumarPartidaJugada: $e');
    }
  }

  Future<void> sumarPartidaGuanyada(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return;
      }

      final response = await http.put(
        Uri.parse('https://${Config.ip}/usuaris/partida_guanyada/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _partidesGuanyades += 1;
        notifyListeners();
      } else {
        print('Error sumant partida guanyada: ${response.body}');
      }
    } catch (e) {
      print('Error a sumarPartidaGuanyada: $e');
    }
  }

  Future<List<Avatar>> getAvatars() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://${Config.ip}/usuaris/avatars');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Avatar.fromJson(e)).toList();
    } else {
      throw Exception('Error al carregar els avatars');
    }
  }

  Future<void> actualitzarAvatar(int avatarId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    final url = Uri.parse('https://${Config.ip}/usuaris/actualitzaravatar');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': userId,
        'avatarId': avatarId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('No s\'ha pogut actualitzar l\'avatar: ${response.body}');
    }
  }

  Future<String> obtenirAvatar(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('https://${Config.ip}/usuaris/avatar/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['avatarUrl'];
    } else {
      throw Exception('No s\'ha pogut carregar l\'avatar');
    }
  }

  Future<Map<String, dynamic>> getexpuser(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible");
        throw Exception("Token no disponible");
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/perfils/exp/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(
          'Respuesta del endpoint exp: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'userId': userId,
          'nivell': data['nivell'] ?? 1,
          'exp_max': data['exp_max'] ?? 100,
          'exp_emmagatzemada': data['exp_emmagatzemada'] ?? 0,
        };
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en getexpuser: $e');
      throw Exception('Error al obtener datos de experiencia');
    }
  }

  Future<void> fetchExpData(int userId) async {
    try {
      final expData = await getexpuser(userId);
      notifyListeners();
    } catch (e) {
      print('Error en fetchExpData: $e');
      throw e;
    }
  }

  Future<List<Titol>> fetchTitolsComplets(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return [];
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/perfils/titols/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final titolsJson = data['titols'] as List<dynamic>?;

        if (titolsJson == null) return [];

        return titolsJson.map((e) => Titol.fromJson(e)).toList();
      } else {
        print('Error carregant títols completats: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error a fetchTitolsComplets: $e');
      return [];
    }
  }

  Future<void> carregarTitolUsuari(int userId) async {
    final titol = await fetchTitolUsuari(userId);
    _titolUsuari = titol;
    notifyListeners();
  }

  Future<Titol?> fetchTitolUsuari(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return null;
      }

      final response = await http.get(
        Uri.parse('https://${Config.ip}/perfils/titol/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['titol'] == null) return null;
        return Titol.fromJson(data['titol']);
      } else if (response.statusCode == 404) {
        print('Usuari o títol no trobat');
        return null;
      } else {
        print('Error carregant títol usuari: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error a fetchTitolUsuari: $e');
      return null;
    }
  }

  Future<void> actualitzarTitolUsuari(int userId, int titolId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token no disponible a SharedPreferences");
        return;
      }

      final url =
          Uri.parse('https://${Config.ip}/perfils/actualitzar/titol/$userId');

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'titolId': titolId,
        }),
      );

      if (response.statusCode == 200) {
        print('Títol actualitzat correctament');
        await carregarTitolUsuari(
            userId); // <- aquí s'actualitza localment i notifica
      } else {
        print('Error actualitzant el títol: ${response.body}');
      }
    } catch (e) {
      print('Error a patchTitolUsuari: $e');
    }
  }
}
