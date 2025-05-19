import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../imports.dart';

class CombatProvider with ChangeNotifier {
  double _aliatHealth = 1000.0;
  double _enemicHealth = 1000.0;
  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;

  bool _ultiUsed = false;

  double get aliatHealth => _aliatHealth;
  double get enemicHealth => _enemicHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;

  bool get ultiUsed => _ultiUsed;

  void setAllyHealth(double value) {
    _aliatHealth = value;
    notifyListeners();
  }

  void setEnemyHealth(double value) {
    _enemicHealth = value;
    notifyListeners();
  }

  void setAttackInProgress(bool value) {
    _isAttackInProgress = value;
    notifyListeners();
  }

  void setUltiUsed(bool value) {
    _ultiUsed = value;
    notifyListeners();
  }

  void resetCombat(
      {double maxAllyHealth = 1000.0, double maxEnemyHealth = 1000.0}) {
    _aliatHealth = maxAllyHealth;
    _enemicHealth = maxEnemyHealth;
    _isEnemyTurn = false;
    _isEnemyHit = false;
    _isAllyHit = false;
    _isAttackInProgress = false;
    _ultiUsed = false;
    notifyListeners();
  }

  Future<void> performAttack(
    int allyDamage,
    int enemyDamage,
    int skinId,
    VoidCallback onVictory,
    VoidCallback onDefeat,
  ) async {
    if (!_isEnemyTurn && !_isAttackInProgress && _enemicHealth > 0) {
      _isAttackInProgress = true;
      _isEnemyHit = true;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 300));

      _enemicHealth -= allyDamage;
      if (_enemicHealth < 0) _enemicHealth = 0;

      _isEnemyHit = false;
      _isEnemyTurn = _enemicHealth > 0;
      notifyListeners();

      if (_enemicHealth > 0) {
        await _performEnemyAttack(enemyDamage, skinId, onDefeat);
      } else {
        _isAttackInProgress = false;

        await updateSkinVidaActual(
          skinId: skinId,
          vidaActual: _aliatHealth,
        );

        onVictory();
      }
    }
  }

  Future<void> _performEnemyAttack(
    int enemyDamage,
    int skinId,
    VoidCallback onDefeat,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    _isAllyHit = true;
    notifyListeners();

    _aliatHealth -= enemyDamage;
    if (_aliatHealth < 0) _aliatHealth = 0;

    await Future.delayed(const Duration(milliseconds: 500));

    _isAllyHit = false;
    _isEnemyTurn = false;
    _isAttackInProgress = false;
    notifyListeners();

    if (_aliatHealth <= 0) {
      await updateSkinVidaActual(
        skinId: skinId,
        vidaActual: _aliatHealth,
      );

      onDefeat();
    }
  }

  /// Actualitza la vida al servidor i la guarda localment
  Future<void> updateSkinVidaActual({
    required int skinId,
    required double vidaActual,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final usuariId = prefs.getInt('userId');

      if (token == null || usuariId == null) {
        print("Token o usuari_id no disponible");
        return;
      }

      final response = await http.put(
        Uri.parse('https://${Config.ip}/combats/vida/$skinId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'vida_actual': vidaActual.round(),
          'usuari_id': usuariId,
        }),
      );

      if (response.statusCode == 200) {
        print("Vida actualitzada correctament.");
        _actualitzaVidaLocal(vidaActual);

        // Guardar localment per evitar perdre la vida quan es torna a la pantalla
        await prefs.setDouble('vida_aliat_$skinId', vidaActual);
      } else {
        print("Error al actualitzar vida: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error en updateSkinVidaActual: $e");
    }
  }

  /// Actualitza només la variable local i notifica
  void _actualitzaVidaLocal(double novaVida) {
    _aliatHealth = novaVida;
    notifyListeners();
  }

  /// Carrega la vida aliada desada localment (SharedPreferences)
  Future<void> loadAliatHealthFromStorage(int skinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double? vidaGuardada = prefs.getDouble('vida_aliat_$skinId');
      if (vidaGuardada != null) {
        _aliatHealth = vidaGuardada;
        notifyListeners();
      }
    } catch (e) {
      print("Error carregant vida aliat: $e");
    }
  }
}
