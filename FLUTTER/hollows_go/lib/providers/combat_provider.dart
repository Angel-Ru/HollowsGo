import 'package:http/http.dart' as http;
import '../imports.dart';

class CombatProvider with ChangeNotifier {
  double? _aliatHealth; // Vida del aliado
  double _enemicHealth = 1000.0;

  bool _isEnemyTurn = false;
  bool _isEnemyHit = false;
  bool _isAllyHit = false;
  bool _isAttackInProgress = false;
  bool _ultiUsed = false;

  // Daño base y bonus
  int _basePlayerAttack = 0;
  int _bonusPlayerAttack = 0;

  // NUEVO: Buff de ulti activo
  bool _hasAttackBuff = false;

  // GETTERS
  double get aliatHealth => _aliatHealth ?? 0.0;
  double get enemicHealth => _enemicHealth;
  bool get isEnemyTurn => _isEnemyTurn;
  bool get isEnemyHit => _isEnemyHit;
  bool get isAllyHit => _isAllyHit;
  bool get isAttackInProgress => _isAttackInProgress;
  bool get ultiUsed => _ultiUsed;
  bool get isHealthLoaded => _aliatHealth != null;

  int get playerAttack => _basePlayerAttack + _bonusPlayerAttack;
  int get bonusPlayerAttack => _bonusPlayerAttack;

  // NUEVO: getter para saber si el buff está activo (opcional)
  bool get hasAttackBuff => _hasAttackBuff;

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

  void setBasePlayerAttack(int value) {
    _basePlayerAttack = value;
    notifyListeners();
  }

  void buffPlayerAttack(int amount) {
    _bonusPlayerAttack += amount;
    notifyListeners();
  }

  // NUEVO: método para activar el buff de +300 al daño aliado
  void applyAttackBuff() {
    _hasAttackBuff = true;
    notifyListeners();
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

    _bonusPlayerAttack = 0;
    // _basePlayerAttack = 0; // si quieres reiniciar base

    // NUEVO: resetear buff
    _hasAttackBuff = false;

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

      // NUEVO: si el buff está activo, sumamos +300 al daño aliado
      final int damageToApply = _hasAttackBuff ? allyDamage + 300 : allyDamage;

      _enemicHealth -= damageToApply;
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
