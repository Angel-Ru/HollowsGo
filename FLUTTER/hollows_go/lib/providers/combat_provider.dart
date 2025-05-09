import 'package:flutter/material.dart';

class CombatProvider with ChangeNotifier {
  double _aliatHealth = 1000.0;
  double _enemicHealth = 1000.0;
  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;

  double get aliatHealth => _aliatHealth;
  double get enemicHealth => _enemicHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;

  void setAllyHealth(double value) {
    _aliatHealth = value;
    notifyListeners();
  }

  void setEnemyHealth(double value) {
    _enemicHealth = value;
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
    notifyListeners();
  }

  Future<void> performAttack(int allyDamage, int enemyDamage,
      VoidCallback onVictory, VoidCallback onDefeat) async {
    if (!_isEnemyTurn && !_isAttackInProgress && _enemicHealth > 0) {
      _isAttackInProgress = true;
      _isEnemyHit = true;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: 300));

      _enemicHealth -= allyDamage;
      if (_enemicHealth < 0) _enemicHealth = 0;

      _isEnemyHit = false;
      _isEnemyTurn = _enemicHealth > 0;
      notifyListeners();

      if (_enemicHealth > 0) {
        await _performEnemyAttack(enemyDamage, onDefeat);
      } else {
        _isAttackInProgress = false;
        onVictory();
      }
    }
  }

  Future<void> _performEnemyAttack(
      int enemyDamage, VoidCallback onDefeat) async {
    await Future.delayed(Duration(seconds: 1));

    _isAllyHit = true;
    notifyListeners();

    _aliatHealth -= enemyDamage;
    if (_aliatHealth < 0) _aliatHealth = 0;

    await Future.delayed(Duration(milliseconds: 500));

    _isAllyHit = false;
    _isEnemyTurn = false;
    _isAttackInProgress = false;
    notifyListeners();

    if (_aliatHealth <= 0) {
      onDefeat();
    }
  }
}
