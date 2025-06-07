import '../imports.dart';
import '../service/missionsservice.dart';
import '../widgets/combat/midscreen_turn_indicator.dart';

class CombatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CombatProvider(),
      child: _CombatScreenContent(),
    );
  }
}

class _CombatScreenContent extends StatefulWidget {
  @override
  State<_CombatScreenContent> createState() => _CombatScreenContentState();
}

class _CombatScreenContentState extends State<_CombatScreenContent>
    with AutomaticKeepAliveClientMixin {
  late String _backgroundImage;
  bool _partidaJugadaSumada = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setRandomBackground();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final combatProvider =
          Provider.of<CombatProvider>(context, listen: false);
      final skinsProvider =
          Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

      
      final aliat = skinsProvider.selectedSkinAliat ??
          skinsProvider.selectedSkinQuincy ??
          skinsProvider.selectedSkinEnemic;
      final enemic = skinsProvider.selectedSkin;

      if (enemic != null) {
        final enemySkinName = enemic.personatgeNom;
        final enemySkinHealth = (enemic.vida ?? 1000).toDouble();

        print("🔥 Assignant nom correcte a l'enemic: $enemySkinName");
        combatProvider.setEnemyName(enemySkinName!);
        combatProvider.setEnemyMaxHealth(enemySkinHealth);
        combatProvider.setEnemyHealth(enemySkinHealth);
      }

      if (aliat?.id != null) {
        await combatProvider.fetchSkinVidaActual(aliat!.id);
      }

      final maxEnemyHealth = enemic?.vida ?? 1000;
      combatProvider.resetCombat(
        maxAllyHealth: combatProvider.aliatHealth,
        maxEnemyHealth: maxEnemyHealth.toDouble(),
        keepAllyHealth: true,
      );

      final habilitatProvider =
          Provider.of<HabilitatProvider>(context, listen: false);

      if (aliat != null) {
        await habilitatProvider.loadHabilitatPerSkinId(aliat.id);
      } else {
        habilitatProvider.clearHabilitat();
      }

      if (!_partidaJugadaSumada) {
        final aliatSkin = aliat;
        await MissionsLogic.completarMissioJugarPartida(context,
            aliatSkin: aliatSkin);
        _partidaJugadaSumada = true;
      }
    });
  }

  void _setRandomBackground() {
    final random = Random();
    int index = random.nextInt(5) + 1;
    _backgroundImage = 'lib/images/combatscreen_images/fondo_combat_$index.png';
  }

  void _showVictoryDialog() async {
    final skinsProvider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    await skinsProvider.fetchEnemyPoints();

    await MissionsLogic.completarMissioGuanyarPartida(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VictoryDialog(
        coins: skinsProvider.coinEnemies,
        exp: skinsProvider.coinEnemies,
        onContinue: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        },
      ),
    );
  }

  void _showDefeatDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DefeatDialog(
        onContinue: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final sortir = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken),
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orangeAccent,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Estàs a un combat en curs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Estàs segur que vols sortir de l\'aplicació?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sí'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (sortir == true) {
      SystemNavigator.pop();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<SkinsEnemicsPersonatgesProvider, SelectedSkinsModel>(
      selector: (_, provider) => SelectedSkinsModel(
        aliat: provider.selectedSkinAliat ??
            provider.selectedSkinQuincy ??
            provider.selectedSkinEnemic,
        enemic: provider.selectedSkin,
      ),
      builder: (context, skins, _) {
        final combatProvider = Provider.of<CombatProvider>(context);

        final String allyName = skins.aliat?.nom ?? "Desconegut Aliat";
        final int aliatDamage = skins.aliat?.malTotal ?? 300;
        final String techniqueName = skins.aliat?.atac ?? "Tècnica desconeguda";
        final int enemicDamage = (skins.enemic?.malTotal ?? 50) * 2;

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: Stack(
              children: [
                combatProvider.overrideBackground != null
                    ? CombatBackground(combatProvider.overrideBackground!)
                    : CombatBackground(_backgroundImage),
                Align(
                  alignment: Alignment.center,
                  child: MidScreenTurnIndicator(
                      isEnemyTurn: combatProvider.isEnemyTurn),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CharacterDisplayWidget(
                        imageUrl: skins.enemic?.imatge ??
                            'lib/images/combatscreen_images/aizen_combat.png',
                        name: combatProvider.enemyName,
                        health: combatProvider.enemicHealth,
                        maxHealth: combatProvider.enemyMaxHealth.toInt(),
                        isHit: combatProvider.isEnemyHit,
                        isEnemy: true,
                        debuffAmount: combatProvider.enemyAttackDebuff,
                        isBleeding: combatProvider.enemyBleeding,
                        isFrozen: combatProvider.enemyFrozen,
                        showInkEffect: combatProvider.ichibeJustUsedUlti,
                        showSenjumaruEffect:
                            combatProvider.senjumaruEffectActive,
                        senjumaruAttackCount:
                            combatProvider.senjumaruAttackCount,
                      ),
                      Spacer(),
                      CharacterDisplayWidget(
                        imageUrl: skins.aliat?.imatge ??
                            'lib/images/combatscreen_images/bleach_combat.png',
                        name: allyName,
                        health: combatProvider.aliatHealth,
                        maxHealth: skins.aliat.vidaMaxima,
                        isHit: combatProvider.isAllyHit,
                        buffAmount: combatProvider.bonusAllyDamage,
                        isImmune: combatProvider.playerImmune,
                      ),
                      SizedBox(height: 20),
                      CombatActionButtons(
                        combatProvider: combatProvider,
                        techniqueName: techniqueName,
                        aliatDamage: aliatDamage,
                        enemicDamage: enemicDamage,
                        onVictory: _showVictoryDialog,
                        onDefeat: _showDefeatDialog,
                        skinId: skins.aliat?.id ?? 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SelectedSkinsModel {
  final dynamic aliat;
  final dynamic enemic;

  SelectedSkinsModel({required this.aliat, required this.enemic});
}
