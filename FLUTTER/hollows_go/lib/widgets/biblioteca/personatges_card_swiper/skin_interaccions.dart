import 'package:hollows_go/service/missionsservice.dart';

import '../../../imports.dart';

class SkinInteractionController {
  final BuildContext context;
  final int usuariId;

  const SkinInteractionController({
    required this.context,
    required this.usuariId,
  });

  Future<void> togglePersonatgeFavorite(int personatgeId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isCurrentlyFavorite =
        userProvider.personatgePreferitId == personatgeId;
    await userProvider
        .updatePersonatgePreferit(isCurrentlyFavorite ? 0 : personatgeId);
  }

  Future<void> toggleSkinFavorite(Skin skin) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isCurrentlyFavorite = userProvider.skinPreferidaId == skin.id;
    await userProvider.updateSkinPreferida(isCurrentlyFavorite ? 0 : skin.id);
  }

  Future<void> showArmesDialog(Skin skin) async {
    final armesProvider = Provider.of<ArmesProvider>(context, listen: false);
    await mostrarDialegArmesPredefinides(
      context: context,
      skinId: skin.id,
      usuariId: usuariId,
      armesProvider: armesProvider,
    );
  }

  Future<double?> useVialAndFetchHealth(Skin skin) async {
    final vialsProvider = Provider.of<VialsProvider>(context, listen: false);
    final success = await vialsProvider.utilitzarVial(
      usuariId: usuariId,
      skinId: skin.id,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Vial utilitzat correctament!'
              : 'No tens vials disponibles.',
        ),
      ),
    );

    if (!success) return null;

    await MissionsLogic.completarMissioVial(context);

    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    return await combatProvider.fetchSkinVidaActual(skin.id);
  }
}
