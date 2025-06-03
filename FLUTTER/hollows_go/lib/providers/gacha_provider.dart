import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hollows_go/config.dart';

class GachaProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDuplicateSkin = false;
  bool get isDuplicateSkin => _isDuplicateSkin;

  // Aquí guardare les skins de categoria 4 que siguin shinigamis o aliades(Angel del futuro pensa en modificar el endpoint per afegir les que tenen habilitat llegendaria)
  List<Map<String, dynamic>> _publicSkins = [];
  List<Map<String, dynamic>> get publicSkins => _publicSkins;

  List<Map<String, dynamic>> _latestMultipleSkins = [];
  List<Map<String, dynamic>> get latestMultipleSkins => _latestMultipleSkins;

  Map<String, dynamic>? _latestSkin;
  Map<String, dynamic>? get latestSkin => _latestSkin;

  Map<String, dynamic>? _latestFragmentsSkins;
  Map<String, dynamic>? get latestFragmentsSkins => _latestFragmentsSkins;

  Future<bool> gachaPull(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/simulacio'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        if (response.body.contains("Ja tens aquesta skin")) {
          _latestSkin = {}; // o algún valor no-nulo
          _isDuplicateSkin = true;
        } else {
          final data = json.decode(response.body);
          _latestSkin = data['skin'];
          _isDuplicateSkin = false;
        }
        fetchFragmentsSkinsUsuari(context);

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada de gacha: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> gachaPullQuincy(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/quincys'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        if (response.body.contains("Ja tens aquesta skin")) {
          _latestSkin = {}; // o algún valor no-nulo
          _isDuplicateSkin = true;
        } else {
          final data = json.decode(response.body);
          _latestSkin = data['skin'];
          _isDuplicateSkin = false;
        }
        fetchFragmentsSkinsUsuari(context);

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada de gacha: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> gachaPullEnemics(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/enemics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        if (response.body.contains("Ja tens aquesta skin")) {
          _latestSkin = {}; // o algún valor no-nulo
          _isDuplicateSkin = true;
        } else {
          final data = json.decode(response.body);
          _latestSkin = data['skin'];
          _isDuplicateSkin = false;
        }
        fetchFragmentsSkinsUsuari(context);

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada de gacha: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> gachaPullMultiple(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/multish'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tirades = data['skins'];

        // Guardar les tirades amb info si són duplicades o no
        _latestMultipleSkins = tirades.map<Map<String, dynamic>>((entry) {
          return {
            'skin': entry['skin'],
            'jaTenia': entry['jaTenia'],
          };
        }).toList();
        fetchFragmentsSkinsUsuari(context);

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada múltiple: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> gachaPullMultipleQuincys(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/multiqu'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tirades = data['skins'];

        // Guardar les tirades amb info si són duplicades o no
        _latestMultipleSkins = tirades.map<Map<String, dynamic>>((entry) {
          return {
            'skin': entry['skin'],
            'jaTenia': entry['jaTenia'],
          };
        }).toList();
        fetchFragmentsSkinsUsuari(context);

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada múltiple: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> gachaPullMultipleEnemics(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final response = await http.post(
        Uri.parse('https://${Config.ip}/skins/gacha/multiho'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tirades = data['skins'];

        // Guardar les tirades amb info si són duplicades o no
        _latestMultipleSkins = tirades.map<Map<String, dynamic>>((entry) {
          return {
            'skin': entry['skin'],
            'jaTenia': entry['jaTenia'],
          };
        }).toList();
        fetchFragmentsSkinsUsuari(context);
        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error amb la tirada múltiple: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchSkinsCategoria4Shinigamis(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('https://${Config.ip}/destacats/shinigamis'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _publicSkins = data.cast<Map<String, dynamic>>();
        notifyListeners();
      } else {
        _showError(context, 'Error al obtenir les skins públiques');
      }
    } catch (e) {
      _showError(context, 'Error en carregar les skins: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchSkinsCategoria4Quincy(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('https://${Config.ip}/destacats/quincy'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _publicSkins = data.cast<Map<String, dynamic>>();
        notifyListeners();
      } else {
        _showError(context, 'Error al obtenir les skins públiques');
      }
    } catch (e) {
      _showError(context, 'Error en carregar les skins: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchSkinsCategoria4Hollows(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('https://${Config.ip}/destacats/hollows'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _publicSkins = data.cast<Map<String, dynamic>>();
        notifyListeners();
      } else {
        _showError(context, 'Error al obtenir les skins públiques');
      }
    } catch (e) {
      _showError(context, 'Error en carregar les skins: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> getSkinDelDia(BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final url = Uri.parse('https://${Config.ip}/skins/skindia');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['skin'] == null) {
          _latestSkin = {};
          _isDuplicateSkin = false;
          _showError(
              context, data['message'] ?? 'No s\'ha trobat cap skin del dia.');
        } else {
          _latestSkin = data['skin'];
          _isDuplicateSkin = false;
        }

        notifyListeners();
        return true;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error en obtenir la skin del dia: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> comprarSkinDelDia(
      BuildContext context, int skinId, int personatgeId) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail');
      final token = prefs.getString('token');

      if (email == null || token == null) {
        _showError(context, "No s'ha pogut obtenir el correu o el token.");
        _setLoading(false);
        return false;
      }

      final url = Uri.parse('https://${Config.ip}/skins/skindia/comprar');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'email': email,
          'skinId': skinId,
          'personatgeId': personatgeId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['error'] != null) {
          // Si l'API retorna un error específic
          _showError(context, data['error']);
          return false;
        }

        if (data['message'] != null) {
          _showError(context, data['message']);
        }

        if (data['success'] == true) {
          _latestSkin = data['skin'] ?? {};
          _isDuplicateSkin = false;
          fetchFragmentsSkinsUsuari(context);
          notifyListeners();
          return true;
        } else if (data['alreadyHasSkin'] == true) {
          _isDuplicateSkin = true;
          _showError(context, "Ja tens aquesta skin.");
          return false;
        } else if (data['notEnoughFragments'] == true) {
          _showError(context,
              "No tens fragments suficients per comprar aquesta skin.");
          return false;
        }

        return false;
      } else {
        _showError(context, 'Error: ${response.body}');
        return false;
      }
    } catch (e) {
      _showError(context, 'Error en comprar la skin: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> fetchFragmentsSkinsUsuari(
      BuildContext context) async {
    _setLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final nom = prefs.getString('userName');

      if (token == null || nom == null) {
        _showError(
            context, "No s'ha pogut obtenir el token o el nom d'usuari.");
        return null;
      }

      final url = Uri.parse('https://${Config.ip}/skins/fragments/$nom');

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
          _latestFragmentsSkins = data.first as Map<String, dynamic>;
          notifyListeners();
          return _latestFragmentsSkins;
        } else {
          _showError(
              context, "No s'ha trobat cap fragment per a aquest usuari.");
          return null;
        }
      } else {
        _showError(context, 'Error: ${response.body}');
        return null;
      }
    } catch (e) {
      _showError(context, 'Error en obtenir els fragments: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _latestSkin = null;
    notifyListeners();
  }
}
