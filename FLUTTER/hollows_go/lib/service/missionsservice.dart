import '../imports.dart';
import '../providers/missions_provider.dart';


class MissionsLogic {
  static Future<void> completarMissioJugarPartida(context, {required dynamic aliatSkin}) async {
  final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);

  await missionsProvider.fetchMissions(userProvider.userId);
  perfilProvider.sumarPartidaJugada(userProvider.userId);
  await missionsProvider.incrementarProgresMissioTitol(userProvider.userId);
  
  final missioJugar = missionsProvider.missions.firstWhere(
    (m) => m.missio == 2,
    orElse: () => throw Exception('Missió Jugar no trobada'),
  );

  if (missioJugar.progress < missioJugar.objectiu) {
    await missionsProvider.incrementProgress(missioJugar.id);
  }

 
  try {
    final missio5 = missionsProvider.missions.firstWhere((m) => m.missio == 5);
    if (aliatSkin != null && aliatSkin.raca == 1) {
      if (missio5.progress < missio5.objectiu) {
        await missionsProvider.incrementProgress(missio5.id);
      }
    }
  } catch (_) {
   
  }

  
  try {
    final missio6 = missionsProvider.missions.firstWhere((m) => m.missio == 6);
    if (aliatSkin != null && aliatSkin.raca == 0) {
      if (missio6.progress < missio6.objectiu) {
        await missionsProvider.incrementProgress(missio6.id);
      }
    }
  } catch (_) {
    
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
      await missionsProvider.fetchMissions(userProvider.userId);
    }
  }

 static Future<void> completarMissioEquiparArma(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);

  await missionsProvider.fetchMissions(userProvider.userId);

  final possibles = missionsProvider.missions.where((m) => m.missio == 4);
  if (possibles.isEmpty) return; 

  final missioEquipar = possibles.first;

  if (missioEquipar.progress < missioEquipar.objectiu) {
    await missionsProvider.incrementProgress(missioEquipar.id);
    await missionsProvider.fetchMissions(userProvider.userId);
  }
}

static Future<void> completarMissioVial(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);

  await missionsProvider.fetchMissions(userProvider.userId);

  final possibles = missionsProvider.missions.where((m) => m.missio == 3);
  if (possibles.isEmpty) return; 

  final missioEquipar = possibles.first;

  if (missioEquipar.progress < missioEquipar.objectiu) {
    await missionsProvider.incrementProgress(missioEquipar.id);
    await missionsProvider.fetchMissions(userProvider.userId);
  }
}

}
