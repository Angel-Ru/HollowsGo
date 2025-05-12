// combat_screen.dart
import 'package:hollows_go/providers/combat_provider.dart';
import 'package:hollows_go/providers/perfil_provider.dart';
import 'package:hollows_go/widgets/characterdisplaywidget.dart';

import '../imports.dart';

class CombatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CombatProvider()),
      ],
      child: _CombatScreenContent(),
    );
  }
}

class _CombatScreenContent extends StatefulWidget {
  @override
  _CombatScreenContentState createState() => _CombatScreenContentState();
}

class _CombatScreenContentState extends State<_CombatScreenContent> {
  late String _backgroundImage;
  late String _techniqueName;
  late int _aliatDamage;
  late int _enemicDamage;
  late String _allyName;
  late String _enemyName;

  bool _partidaJugadaSumada = false;  // Variable per controlar la crida

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _setRandomBackground();
      await _selectRandomSkinAndResetHealth();

      // Comprovem si la variable ha estat reiniciada abans de sumar la partida
      if (!_partidaJugadaSumada) {
        final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        perfilProvider.sumarPartidaJugada(userProvider.userId);
        _partidaJugadaSumada = true;  // Marquem la funció com a ja cridada
      }
    });
  }

  Future<void> _selectRandomSkinAndResetHealth() async {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    await provider.selectRandomSkin();

    final aliat = 
    provider.selectedSkinAliat ??
    provider.selectedSkinQuincy ??
    provider.selectedSkinEnemic;

    final skinAliat = aliat;
    final skinEnemic = provider.selectedSkin;

    final maxAllyHealth = skinAliat?.vida ?? 1000;
    final maxEnemyHealth = skinEnemic?.vida ?? 1000;

    provider.setMaxAllyHealth(maxAllyHealth);
    provider.setMaxEnemyHealth(maxEnemyHealth);

    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    combatProvider.resetCombat(
      maxAllyHealth: maxAllyHealth.toDouble(),
      maxEnemyHealth: maxEnemyHealth.toDouble(),
    );

    // Reiniciem la variable per permetre una nova crida en el proper combat
    _partidaJugadaSumada = false;  // Reiniciem la variable aquí
  }

  void _setRandomBackground() {
    final random = Random();
    int randomIndex = random.nextInt(5) + 1;
    _backgroundImage =
        'lib/images/combatscreen_images/fondo_combat_$randomIndex.png';
  }

  void _showVictoryDialog() async {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    await provider.fetchEnemyPoints();
    final partidaguanyda = Provider.of<PerfilProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);;
    partidaguanyda.sumarPartidaGuanyada(userProvider.userId);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Has guanyat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254176/OTHERS/yslqndyf4eri3f7mpl6i.png',
              ),
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
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Has perdut"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254233/COMBATSCREEN/yhh1xy0qy4lumw9v7jtd.png',
              ),
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
    final combatProvider = Provider.of<CombatProvider>(context);
    

    final skinEnemic = provider.selectedSkin;
    final aliat = 
    provider.selectedSkinAliat ?? 
    provider.selectedSkinQuincy ?? 
    provider.selectedSkinEnemic;
    final skinAliat = aliat;

    _allyName = skinAliat?.nom ?? "Desconegut Aliat";
    _aliatDamage = skinAliat?.malTotal ?? 300;
    _techniqueName = skinAliat?.atac ?? "Tècnica desconeguda";
    _enemyName = skinEnemic?.personatgeNom ?? "Desconegut Enemic";
    _enemicDamage = (skinEnemic?.malTotal ?? 50) * 2;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: combatProvider.isEnemyTurn ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                combatProvider.isEnemyTurn
                    ? "Torn: $_enemyName"
                    : "Torn: $_allyName",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CharacterDisplayWidget(
                  imageUrl: skinEnemic?.imatge ??
                      'lib/images/combatscreen_images/aizen_combat.png',
                  name: _enemyName,
                  health: combatProvider.enemicHealth,
                  maxHealth: skinEnemic?.vida ?? 1000,
                  isHit: combatProvider.isEnemyHit,
                  isEnemy: true,
                ),
                Spacer(),
                CharacterDisplayWidget(
                  imageUrl: skinAliat?.imatge ??
                      'lib/images/combatscreen_images/bleach_combat.png',
                  name: _allyName,
                  health: combatProvider.aliatHealth,
                  maxHealth: skinAliat?.vida ?? 1000,
                  isHit: combatProvider.isAllyHit,
                ),
                SizedBox(height: 20),
                _buildActionButtons(context, combatProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, CombatProvider combatProvider) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: combatProvider.isEnemyTurn ||
                      combatProvider.isAttackInProgress ||
                      combatProvider.enemicHealth <= 0
                  ? null
                  : () => combatProvider.performAttack(
                        _aliatDamage,
                        _enemicDamage,
                        _showVictoryDialog,
                        _showDefeatDialog,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Column(
                children: [
                  Text("LLUITA", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _techniqueName,
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
                    "(MAL: $_aliatDamage)",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.auto_awesome, color: Colors.black),
                onPressed: () {
                  // Lógica del botón amarillo
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
