import '../imports.dart';

/*
A la combatScreen es crea la pantalla de combat. En aquesta pantalla es realitza el combat entre el personatge i l'enemic.
Es pot accedir a ella des de la pantalla de mapa, quan l'usuari toca un Hollow.
En aquesta pantalla es mostren les dades del combat, com la salut del personatge i de l'enemic, el nom del personatge i de l'enemic, la imatge del personatge i de l'enemic, etc.
Té els fons de combat aleatoris.
*/

class CombatScreen extends StatefulWidget {
  @override
  _CombatScreenState createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;
  bool _isVideoPlaying = true;

  int punts = 100;
  double aliatHealth = 1000.0;
  double enemicHealth = 1000.0;
  int aliatDamage = 300;
  int enemicDamage = 50;
  String AllyName = "Ichigo Kurosaki";
  String EnemyName = "Sosuke Aizen";
  String backgroundImage = 'lib/images/combat_proves/fondo_combat_1.png';
  bool isEnemyTurn = false;
  bool isEnemyHit = false;
  bool isAllyHit = false;
  bool isAttackInProgress = false;
  String techniqueName =
      "Katen Kyokotsu: Karamatsu Shinju (Suicidi dels Pins Negres)";

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    _setRandomBackground();
    _selectRandomSkin();
    _resetHealth();
  }

  void _resetHealth() {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    final skinAliat = provider.selectedSkinAliat;
    final skinEnemic = provider.selectedSkin;

    provider.setMaxAllyHealth(skinAliat?.vida ?? 1000);
    provider.setMaxEnemyHealth(skinEnemic?.vida ?? 1000);

    provider.resetHealth();
  }

  void _initializeVideoPlayer() {
    _videoController =
        VideoPlayerController.asset('lib/videos/animacion_combate.mp4')
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
              _videoController.play();
            }
          });

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      allowFullScreen: false,
      showControls: false,
    );

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration) {
        setState(() {
          _isVideoPlaying = false;
        });
      }
    });
  }

  void _setRandomBackground() {
    final random = Random();
    int randomIndex = random.nextInt(5) + 1;
    setState(() {
      backgroundImage =
          'lib/images/combat_proves/fondo_combat_$randomIndex.png';
    });
  }

  void _selectRandomSkin() {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    provider.selectRandomSkin();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _attack() {
    if (!isEnemyTurn && !isAttackInProgress) {
      setState(() {
        isAttackInProgress = true;
        isEnemyHit = true;
        final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context,
            listen: false);

        provider.updateEnemyHealth(enemicHealth.toInt() - aliatDamage.toInt());

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

        final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context,
            listen: false);
        provider.updateAllyHealth(aliatHealth.toInt() - enemicDamage.toInt());

        aliatHealth -= enemicDamage;
        if (aliatHealth < 0) aliatHealth = 0;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          isAllyHit = false;
          isEnemyTurn = false;
          isAttackInProgress = false;
        });
      });

      if (enemicHealth <= 0) {
        _showVictoryDialog();
      } else if (aliatHealth <= 0) {
        _showDefeatDialog();
      }
    });
  }

  void _showVictoryDialog() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    await provider.fetchEnemyPoints();

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
            Text(
              "+${provider.coinEnemies}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context);
    final skinEnemic = provider.selectedSkin;
    final skinAliat = provider.selectedSkinAliat;

    AllyName = skinAliat?.nom ?? "Desconegut Aliat";
    aliatDamage = skinAliat?.malTotal ?? 300;
    aliatHealth = skinAliat?.currentHealth?.toDouble() ?? 1000;
    techniqueName = skinAliat!.atac!;
    EnemyName = skinEnemic?.personatgeNom ?? "Desconegut Enemic";
    enemicDamage = skinEnemic?.malTotal ?? 50;
    enemicHealth = skinEnemic?.currentHealth?.toDouble() ?? 1000;

    return Scaffold(
      body: _isVideoPlaying
          ? Container(
              color: Colors.black,
              child: Center(
                child: _videoController.value.isInitialized
                    ? Chewie(controller: _chewieController)
                    : CircularProgressIndicator(),
              ),
            )
          : Stack(
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
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                            child: Image.network(
                              skinEnemic?.imatge ??
                                  'lib/images/combat_proves/aizen_combat.png',
                              height: 300,
                              width: 300,
                            ),
                          ),
                          SizedBox(height: 1),
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
                                _buildHealthBar(
                                    enemicHealth, skinEnemic?.vida ?? 1000),
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
                            child: Image.network(
                              skinAliat?.imatge ??
                                  'lib/images/combat_proves/bleach_combat.png',
                              height: 250,
                              width: 250,
                            ),
                          ),
                          SizedBox(height: 0),
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
                                    _buildHealthBar(
                                        aliatHealth, skinAliat?.vida ?? 1000),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("LLUITA",
                                          style: TextStyle(fontSize: 18)),
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
        Container(
          width: 200,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
        ),
        Positioned(
          left: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 200 * healthPercentage,
              height: 24,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Text(
          "${health.toInt()}/$maxHealth",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
