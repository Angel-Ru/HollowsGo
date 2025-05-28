import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class CombatProvider with ChangeNotifier {
  double? _aliatHealth;
  double _enemicHealth = 1000.0;
  double _enemyMaxHealth = 1000.0;

  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;
  bool _ultiUsed = false;
  bool _enemyFrozen = false;
  bool _enemyBleeding = false;
  bool _ichibeJustUsedUlti = false;
  bool _playerImmune = false;

  int _bleedTick = 0;
  int _bonusAllyDamage = 0;
  int _enemyAttackDebuff = 0;
  int _turnsUntilEnemyDies = -1;

  String _enemyName = "Enemic";
  String? _overrideBackground;

  // GETTERS
  double get aliatHealth => _aliatHealth ?? 0.0;
  double get enemicHealth => _enemicHealth;
  double get enemyMaxHealth => _enemyMaxHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;
  bool get ultiUsed => _ultiUsed;
  int get bonusAllyDamage => _bonusAllyDamage;
  int get enemyAttackDebuff => _enemyAttackDebuff;
  bool get enemyFrozen => _enemyFrozen;
  bool get enemyBleeding => _enemyBleeding;
  String get enemyName => _enemyName;
  bool get ichibeJustUsedUlti => _ichibeJustUsedUlti;
  String? get overrideBackground => _overrideBackground;
  bool get playerImmune => _playerImmune;
  int get turnsUntilEnemyDies => _turnsUntilEnemyDies;

  // SETTERS
  void setAllyHealth(double value) {
    _aliatHealth = value.clamp(0, double.infinity);
    notifyListeners();
  }

  void setEnemyHealth(double value) {
    _enemicHealth = value.clamp(0, _enemyMaxHealth);
    notifyListeners();
  }

  void setEnemyMaxHealth(double value) {
    _enemyMaxHealth = value;
    if (_enemicHealth > _enemyMaxHealth) {
      _enemicHealth = _enemyMaxHealth;
    }
    notifyListeners();
  }

  void setEnemyName(String value) {
    _enemyName = value;
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

  void setOverrideBackground(String? value) {
    _overrideBackground = value;
    notifyListeners();
  }

  void setEnemyFrozen(bool value) {
    _enemyFrozen = value;
    notifyListeners();
  }

  void setPlayerImmune(bool value) {
    _playerImmune = value;
    notifyListeners();
  }

  void healPlayer(int amount, int maxHealth) {
    _aliatHealth = (_aliatHealth ?? 0) + amount;
    if (_aliatHealth! > maxHealth) _aliatHealth = maxHealth.toDouble();
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

  void applyBleed() {
    if (_enemyBleeding) return;
    _enemyBleeding = true;
    _bleedTick = 0;
    notifyListeners();
  }

  void processTurn({VoidCallback? onEnemyDefeated}) {
    if (_turnsUntilEnemyDies > 0) {
      decrementDoomCounter(onEnemyDefeated: onEnemyDefeated);
    }
    notifyListeners();
  }

  void applyDoomEffect() {
    _turnsUntilEnemyDies = 3;
    notifyListeners();
  }

  Future<void> decrementDoomCounter({VoidCallback? onEnemyDefeated}) async {
    if (_turnsUntilEnemyDies > 0) {
      _turnsUntilEnemyDies--;
      if (_turnsUntilEnemyDies == 0) {
        await Future.delayed(const Duration(milliseconds: 600)); // Pausa visual
        setEnemyHealth(0);
        clearDoomEffect();
        _enemyBleeding = false; // Assegurem que bleed s'atura
        _isAttackInProgress = false; // No deixar bloquejat
        notifyListeners();
        if (onEnemyDefeated != null) {
          onEnemyDefeated();
        }
      } else {
        notifyListeners();
      }
    }
  }

  void clearDoomEffect() {
    _turnsUntilEnemyDies = -1;
    notifyListeners();
  }

  Map<String, dynamic> ichibeUltimateEffect({
    required String enemyName,
    required double enemyMaxHealth,
    required int enemyAttack,
  }) {
    int midIndex = (enemyName.length / 2).ceil();
    String modifiedName = enemyName.substring(0, midIndex);

    double newMaxHealth = enemyMaxHealth / 2;
    if (_enemicHealth > newMaxHealth) {
      _enemicHealth = newMaxHealth;
    }

    _enemyMaxHealth = newMaxHealth;
    _enemyName = modifiedName;

    int attackDebuff = (enemyAttack / 2).floor();
    notifyListeners();

    return {
      'modifiedName': modifiedName,
      'newMaxHealth': newMaxHealth,
      'attackDebuff': attackDebuff,
    };
  }

  void triggerIchibeUltiEffect() {
    _ichibeJustUsedUlti = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _ichibeJustUsedUlti = false;
      notifyListeners();
    });
  }

  void processBleedTick({VoidCallback? onEnemyDefeated}) {
    if (!_enemyBleeding || _enemicHealth <= 0) return;

    double bleedDamage = 100 * (pow(1.2, _bleedTick) as double);
    _bleedTick += 1;
    _enemicHealth -= bleedDamage;
    if (_enemicHealth < 0) _enemicHealth = 0;

    notifyListeners();

    if (_enemicHealth == 0) {
      _enemyBleeding = false;
      clearDoomEffect();
      _isAttackInProgress = false; // Evitem bloqueig
      notifyListeners();
      if (onEnemyDefeated != null) {
        onEnemyDefeated();
      }
    }
  }

  void checkVictory(VoidCallback onVictory) {
    if (_enemicHealth <= 0) {
      clearDoomEffect();
      onVictory();
    }
  }

  void resetCombat({
    double maxAllyHealth = 1000.0,
    double maxEnemyHealth = 1000.0,
    bool keepAllyHealth = false,
  }) {
    if (!keepAllyHealth) _aliatHealth = maxAllyHealth;
    _enemicHealth = maxEnemyHealth;
    _enemyMaxHealth = maxEnemyHealth;
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
    clearDoomEffect();
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

      await Future.delayed(const Duration(milliseconds: 800));

      final totalAllyDamage = allyDamage + _bonusAllyDamage;
      _bonusAllyDamage = 0;

      _enemicHealth -= totalAllyDamage;
      if (_enemicHealth < 0) _enemicHealth = 0;

      _isEnemyHit = false;
      notifyListeners();

      if (_enemicHealth <= 0) {
        clearDoomEffect();
        _enemyBleeding = false;
        _isAttackInProgress = false;
        await updateSkinVidaActual(
            skinId: skinId, vidaActual: _aliatHealth ?? 0);
        onVictory();
        return;
      }

      _isEnemyTurn = true;
      notifyListeners();

      // Atac enemic
      await _performEnemyAttack(enemyDamage, skinId, onDefeat,
          onVictory: onVictory);

      // Aplicar Doom després d’atac enemic
      decrementDoomCounter(onEnemyDefeated: onVictory);
    }
  }

  Future<void> _performEnemyAttack(
    int enemyDamage,
    int skinId,
    VoidCallback onDefeat, {
    VoidCallback? onVictory,
  }) async {
    if (_enemyFrozen) {
      _isEnemyTurn = false;
      _isAttackInProgress = false;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    _isAllyHit = true;
    notifyListeners();

    if (!_playerImmune) {
      final effectiveDamage = max(0, enemyDamage - _enemyAttackDebuff);
      _aliatHealth = (_aliatHealth ?? 0) - effectiveDamage;
      if (_aliatHealth! < 0) _aliatHealth = 0;
    }

    await Future.delayed(const Duration(milliseconds: 600));
    _isAllyHit = false;

    // Process bleed tick només si enemic viu
    if (_enemyBleeding && _enemicHealth > 0) {
      processBleedTick(onEnemyDefeated: onVictory);
    }

    _isEnemyTurn = false;
    _isAttackInProgress = false;
    notifyListeners();

    if (_aliatHealth! <= 0) {
      await updateSkinVidaActual(skinId: skinId, vidaActual: _aliatHealth!);
      onDefeat();
    }

    // Executa Doom després
    decrementDoomCounter(onEnemyDefeated: onVictory);
  }

  Future<void> updateSkinVidaActual({
    required int skinId,
    required double vidaActual,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final usuariId = prefs.getInt('userId');

      if (token == null || usuariId == null) return;

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

      if (response.statusCode != 200) {
        print(
            "Error actualitzant vida: ${response.statusCode}, ${response.body}");
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

      if (token == null || usuariId == null) return null;

      final response = await http.get(
        Uri.parse(
            'https://${Config.ip}/combats/vida/$skinId?usuari_id=$usuariId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final vida = (data['vida_actual'] as num).toDouble();
        setAllyHealth(vida);
        return vida;
      } else {
        print("Error obtenint vida: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error en fetchSkinVidaActual: $e");
      return null;
    }
  }
}
