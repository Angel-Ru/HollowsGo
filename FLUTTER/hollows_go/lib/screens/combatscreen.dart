import 'package:hollows_go/imports.dart';

class CombatScreen extends StatefulWidget {
  @override
  _CombatScreenState createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  // Mondedes
  int punts = 100;
  double aliatHealth = 1000.0;
  double enemicHealth = 1000.0;

  int aliatDamage = 50;
  int enemicDamage = 50;

  String AllyName = "Ichigo Kurosaki";
  String EnemyName = "Sosuke Aizen";
  String backgroundImage = 'lib/images/combat_proves/fondo_combat_1.png';

  bool isEnemyTurn = false;
  bool isEnemyHit = false;
  bool isAllyHit = false;

  bool isAttackInProgress = false; // Nueva variable para bloquear el ataque
  String techniqueName =
      "Katen Kyokotsu: Karamatsu Shinju (Suicidi dels Pins Negres)";

  @override
  void initState() {
    super.initState();
    _setRandomBackground();
  }

  void _setRandomBackground() {
    final random = Random();
    int randomIndex = random.nextInt(5) + 1;
    setState(() {
      backgroundImage =
          'lib/images/combat_proves/fondo_combat_$randomIndex.png';
    });
  }

  void _attack() {
    if (!isEnemyTurn && !isAttackInProgress) {
      setState(() {
        isAttackInProgress = true; // Bloquea el botón durante el ataque
        isEnemyHit = true;
        enemicHealth -= aliatDamage;
        if (enemicHealth < 0) enemicHealth = 0;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          isEnemyHit = false;
          isEnemyTurn = true;
        });
        _enemyAttack();
      });
    }
  }

  void _enemyAttack() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isAllyHit = true;
        aliatHealth -= enemicDamage;
        if (aliatHealth < 0) aliatHealth = 0;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isAllyHit = false;
          isEnemyTurn = false;
          isAttackInProgress = false; // Permite el siguiente ataque
        });
      });

      // Comprobamos si el combate ha terminado
      if (enemicHealth <= 0) {
        _showVictoryDialog();
      } else if (aliatHealth <= 0) {
        _showDefeatDialog();
      }
    });
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Has guanyat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/images/kan_moneda.png'),
            ),
            SizedBox(height: 10),
            Text("+$punts",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text("Continuar"),
          ),
        ],
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Has perdut"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/images/kon_plorant.png'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            child: Text("Continuar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isEnemyTurn ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isEnemyTurn ? "Torn: $EnemyName" : "Torn: $AllyName",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: isEnemyHit ? 0.5 : 1.0,
                      child: Image.asset(
                        'lib/images/combat_proves/aizen_combat.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              "$EnemyName",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(width: 10),
                          _buildHealthBar(enemicHealth, 1000),
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 300),
                      opacity: isAllyHit ? 0.5 : 1.0,
                      child: Image.asset(
                        'lib/images/combat_proves/bleach_combat.png',
                        height: 250,
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildHealthBar(aliatHealth, 1000),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  "$AllyName",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isEnemyTurn || isAttackInProgress
                                ? null
                                : _attack,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("LLUITA", style: TextStyle(fontSize: 18)),
                                SizedBox(height: 4),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    techniqueName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "(MAL: $aliatDamage)",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(double health, int maxHealth) {
    double healthPercentage = health / maxHealth;
    Color barColor = healthPercentage < 0.2
        ? Colors.red
        : (healthPercentage < 0.6 ? Colors.orange : Colors.green);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Contenedor del borde negro, colocado por encima
        Positioned(
          child: Container(
            width: 200,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black, width: 2), // Borde negro
            ),
          ),
        ),
        // Barra de vida dentro del contenedor, comenzando desde la derecha
        Positioned(
          left: 0, // Posicionamos la barra a la izquierda
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 200 *
                  healthPercentage, // Ancho ajustado según el porcentaje de vida
              height: 24, // Alto de la barra de vida
              decoration: BoxDecoration(
                  color: barColor, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        // Texto con la cantidad de vida
        Positioned(
          child: Text("${health.toInt()}/$maxHealth",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
