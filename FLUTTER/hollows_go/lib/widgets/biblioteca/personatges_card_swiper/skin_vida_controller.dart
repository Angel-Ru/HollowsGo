import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/skin.dart';
import '../../../providers/combat_provider.dart';
import 'skin_interaccions.dart';

class SkinHealthController {
  final BuildContext context;
  final SkinInteractionController skinController;
  final Map<int, double?> _vidaPerSkin = {};

  bool animarBarraVida = false;

  SkinHealthController({
    required this.context,
    required this.skinController,
  });

  double? getVida(int skinId) => _vidaPerSkin[skinId];

  Future<void> carregarVidaPerSkinsAroundPage(List<Skin> skins, int page) async {
    final combatProvider = Provider.of<CombatProvider>(context, listen: false);
    final indices = <int>{page};

    if (page - 1 >= 0) indices.add(page - 1);
    if (page + 1 < skins.length) indices.add(page + 1);

    for (final i in indices) {
      final skin = skins[i];
      if (_vidaPerSkin.containsKey(skin.id)) continue;

      final vida = await combatProvider.fetchSkinVidaActual(skin.id);
      _vidaPerSkin[skin.id] = vida;
    }
  }

  Future<double?> usarVialISync(Skin skin) async {
    final novaVida = await skinController.useVialAndFetchHealth(skin);
    if (novaVida != null) {
      _vidaPerSkin[skin.id] = novaVida;
    }
    return novaVida;
  }
}
