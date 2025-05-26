import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class CombatProvider with ChangeNotifier {
  double? _aliatHealth;
  double _enemicHealth = 1000.0;
  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;
  bool _ultiUsed = false;
  bool _enemyFrozen = false;

  bool _enemyBleeding = false;
  int _bleedTick = 0;

  int _bonusAllyDamage = 0;
  int _enemyAttackDebuff = 0;

  String? _overrideBackground;
  String? get overrideBackground => _overrideBackground;

  // GETTERS
  double get aliatHealth => _aliatHealth ?? 0.0;
  double get enemicHealth => _enemicHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;
  bool get ultiUsed => _ultiUsed;
  int get bonusAllyDamage => _bonusAllyDamage;
  int get enemyAttackDebuff => _enemyAttackDebuff;
  bool get enemyFrozen => _enemyFrozen;
  bool get enemyBleeding => _enemyBleeding;

  // SETTERS
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

  void healPlayer(int amount) {
    _aliatHealth = (_aliatHealth ?? 0) + amount;
    if (_aliatHealth! > 1000) _aliatHealth = 1000; // límit màxim si vols
    notifyListeners();
  }

  void buffPlayerAttack(int amount) {
    _bonusAllyDamage = amount;
    notifyListeners();
  }

  void applyEnemyAttackDebuff(int amount) {
    _enemyAttackDebuff = amount;
    notifyListeners();
  }

  void setOverrideBackground(String? value) {
    _overrideBackground = value;
    notifyListeners();
  }

  void setEnemyFrozen(bool frozen) {
    _enemyFrozen = frozen;
    notifyListeners();
  }

  void applyBleed() {
    _enemyBleeding = true;
    _bleedTick = 0;
    notifyListeners();
  }

  void tickBleedDamage() {
    if (_enemyBleeding && _enemicHealth > 0) {
      double bleedDamage = 100 * (pow(1.2, _bleedTick) as double);
      _bleedTick += 1;
      _enemicHealth -= bleedDamage;
      if (_enemicHealth < 0) _enemicHealth = 0;
      notifyListeners();
    }
  }

  void resetCombat({
    double maxAllyHealth = 1000.0,
    double maxEnemyHealth = 1000.0,
    bool keepAllyHealth = false,
  }) {
    if (!keepAllyHealth) {
      _aliatHealth = maxAllyHealth;
    }
    _enemicHealth = maxEnemyHealth;
    _isEnemyTurn = false;
    _isEnemyHit = false;
    _isAllyHit = false;
    _isAttackInProgress = false;
    _ultiUsed = false;
    _bonusAllyDamage = 0;
    _enemyAttackDebuff = 0;
    _enemyBleeding = false;
    _bleedTick = 0;
    _overrideBackground = null;
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

      final totalAllyDamage = allyDamage + _bonusAllyDamage;
      _bonusAllyDamage = 0;

      _enemicHealth -= totalAllyDamage;
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
          vidaActual: _aliatHealth ?? 0,
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
    tickBleedDamage(); // 🔴 Aplicar sangrat abans del torn enemic

    if (_enemyFrozen) {
      debugPrint('[DEBUG] Torn enemic congelat: no ataca.');
      _isEnemyTurn = false;
      _isAttackInProgress = false;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    _isAllyHit = true;
    notifyListeners();

    final effectiveDamage = enemyDamage - _enemyAttackDebuff;
    final damage = effectiveDamage > 0 ? effectiveDamage : 0;

    debugPrint('[DEBUFF DEBUG] Ataque enemigo: '
        'Original=$enemyDamage, '
        'Debuff=-$_enemyAttackDebuff, '
        'Total=$damage');

    _aliatHealth = (_aliatHealth ?? 0) - damage;
    if (_aliatHealth! < 0) _aliatHealth = 0;

    await Future.delayed(const Duration(milliseconds: 500));
    _isAllyHit = false;
    _isEnemyTurn = false;
    _isAttackInProgress = false;
    notifyListeners();

    if (_aliatHealth! <= 0) {
      await updateSkinVidaActual(
        skinId: skinId,
        vidaActual: _aliatHealth!,
      );
      onDefeat();
    }
  }

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
      } else {
        print(
            "Error al actualitzar vida: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Error en updateSkinVidaActual: $e");
    }
  }

  Future<double?> fetchSkinVidaActual(int skinId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final usuariId = prefs.getInt('userId');

      if (token == null || usuariId == null) {
        print("Token o usuari_id no disponible");
        return null;
      }

      final response = await http.get(
        Uri.parse(
            'https://${Config.ip}/combats/vida/$skinId?usuari_id=$usuariId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final vida = (data['vida_actual'] as num).toDouble();
        setAllyHealth(vida);
        print("Vida actual obtinguda: $vida");
        return vida;
      } else {
        print(
            "Error al obtenir vida: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error en fetchSkinVidaActual: $e");
      return null;
    }
  }
}
