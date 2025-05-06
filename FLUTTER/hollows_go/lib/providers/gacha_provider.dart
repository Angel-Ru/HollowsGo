import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hollows_go/config.dart';

class GachaProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isDuplicateSkin = false;

  Map<String, dynamic>? _latestSkin;
  Map<String, dynamic>? get latestSkin => _latestSkin;

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
      Uri.parse('https://${Config.ip}/skins/gacha'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _latestSkin = data['skin'];  // Esta es la skin obtenida
      isDuplicateSkin = false;    // No es repetida
      notifyListeners();
      return true;
    } else if (response.body == "Ja tens aquesta skin.") {
      
      _latestSkin = null;
      isDuplicateSkin = true;
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
