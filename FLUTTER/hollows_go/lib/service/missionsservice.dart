import 'package:provider/provider.dart';
import '../providers/missions_provider.dart';
import '../providers/perfil_provider.dart';
import '../providers/user_provider.dart';

class MissionsLogic {
  static Future<void> completarMissioJugarPartida(context) async {
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    missionsProvider.fetchMissions(userProvider.userId);
    perfilProvider.sumarPartidaJugada(userProvider.userId);

    final missioJugar = missionsProvider.missions.firstWhere(
      (m) => m.missio == 2,
      orElse: () => throw Exception('Missió Jugar no trobada'),
    );

    if (missioJugar.progress < missioJugar.objectiu) {
      await missionsProvider.incrementProgress(missioJugar.id);
    }
  }

  static Future<void> completarMissioGuanyarPartida(context) async {
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
    

    missionsProvider.fetchMissions(userProvider.userId);
    perfilProvider.sumarPartidaGuanyada(userProvider.userId);

    final missioGuanyar = missionsProvider.missions.firstWhere(
      (m) => m.missio == 1,
      orElse: () => throw Exception('Missió Guanyar no trobada'),
    );

    if (missioGuanyar.progress < missioGuanyar.objectiu) {
      await missionsProvider.incrementProgress(missioGuanyar.id);
      await missionsProvider.fetchMissions(userProvider.userId); // recarrega
    }
  }
}
