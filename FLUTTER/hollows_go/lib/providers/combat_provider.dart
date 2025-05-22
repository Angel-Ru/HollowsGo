import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../imports.dart';

// combat_provider.dart

class CombatProvider with ChangeNotifier {
  double? _aliatHealth;
  double _enemicHealth = 1000.0;
  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;
  bool _ultiUsed = false;
  int _bonusAllyDamage = 0; // <-- NUEVO: buff de ataque aliado

  // NUEVAS PROPIEDADES PARA DEBUFFS DE ENEMIGO
  String _enemyName = "Enemic"; // ejemplo nombre inicial
  String _originalEnemyName = "Enemic";
  int _enemyAttack = 100; // ataque enemigo base
  int _originalEnemyAttack = 100;
  double _enemyMaxHealth = 1000.0; // vida máxima enemiga
  double _originalEnemyMaxHealth = 1000.0;

  // GETTERS
  double get aliatHealth => _aliatHealth ?? 0.0;
  double get enemicHealth => _enemicHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;
  bool get ultiUsed => _ultiUsed;

  int get bonusAllyDamage => _bonusAllyDamage;

  String get enemyName => _enemyName;
  int get enemyAttack => _enemyAttack;
  double get enemyMaxHealth => _enemyMaxHealth;

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

  // Buff de ataque aliado
  void buffPlayerAttack(int amount) {
    _bonusAllyDamage = amount;
    notifyListeners();
  }

  // DEBUFF: Cortar nombre enemigo a la mitad
  void cutEnemyNameInHalf() {
    _originalEnemyName = _enemyName;
    int halfLength = (_enemyName.length / 2).ceil();
    _enemyName = _enemyName.substring(0, halfLength);
    notifyListeners();
  }

  // DEBUFF: Reducir ataque enemigo a la mitad
void applyEnemyDebuffAttack(int newAttackValue) {
  _enemyAttack = newAttackValue;
  notifyListeners();
}

  // DEBUFF: Reducir vida máxima enemigo a la mitad
  void reduceEnemyMaxHealthByHalf() {
    _originalEnemyMaxHealth = _enemyMaxHealth;
    _enemyMaxHealth = _enemyMaxHealth / 2;

    // Si la vida actual es mayor que la nueva max, ajustamos
    if (_enemicHealth > _enemyMaxHealth) {
      _enemicHealth = _enemyMaxHealth;
    }
    notifyListeners();
  }

  // Resetea el combate y también restaura los valores originales enemigos
  void resetCombat({
    double maxAllyHealth = 1000.0,
    double maxEnemyHealth = 1000.0,
    bool keepAllyHealth = false,
  }) {
    if (!keepAllyHealth) {
      _aliatHealth = maxAllyHealth;
    }
    _enemicHealth = maxEnemyHealth;
    _enemyMaxHealth = maxEnemyHealth;
    _enemyAttack = _originalEnemyAttack;
    _enemyName = _originalEnemyName;
    _isEnemyTurn = false;
    _isEnemyHit = false;
    _isAllyHit = false;
    _isAttackInProgress = false;
    _ultiUsed = false;
    _bonusAllyDamage = 0; // Reiniciamos el buff aquí
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

      // Aplicar bonus de daño si lo hay
      final totalAllyDamage = allyDamage + _bonusAllyDamage;
      _bonusAllyDamage = 0; // Se consume el buff

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
    await Future.delayed(const Duration(seconds: 1));

    _isAllyHit = true;
    notifyListeners();

    _aliatHealth = (_aliatHealth ?? 0) - enemyDamage;
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
