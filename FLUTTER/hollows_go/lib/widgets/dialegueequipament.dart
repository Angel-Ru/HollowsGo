import 'package:hollows_go/imports.dart';
import 'package:hollows_go/providers/armes_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../service/missionsservice.dart';


Future<void> mostrarDialegArmesPredefinides({
  required BuildContext context,
  required int skinId,
  required int usuariId,
  required ArmesProvider armesProvider,
}) async {
  await armesProvider.fetchArmesPerSkin(skinId, usuariId);
  final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
  final skin = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.orange.shade700.withOpacity(0.7),
              ],
              stops: [0.75, 1.0],  // 75% negre, 25% taronja
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade300.withOpacity(0.8), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [  
                  const SizedBox(width: 12),
                  Text(
                    "Selector d'armes",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              if (armesProvider.armaEquipada != null) ...[
                const SizedBox(height: 12),
                Text(
                  "Arma equipada:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  armesProvider.armaEquipada!.nom,
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(
                  color: Colors.orangeAccent,
                  thickness: 1,
                  height: 24,
                ),
              ],

              const SizedBox(height: 10),
              if (armesProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (armesProvider.armesDisponibles.isEmpty)
                Text(
                  "No hi ha armes disponibles.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: armesProvider.armesDisponibles.length,
                    itemBuilder: (context, index) {
                      final arma = armesProvider.armesDisponibles[index];
                      final isEquipada = armesProvider.armaEquipada?.id == arma.id;
                      return Card(
                        color: Colors.black.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.orange.shade300, width: 1),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            arma.nom,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.bolt,
                                color: Colors.orangeAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 6,),
                              Text(
                                '+${arma.buffAtac} d\'atac',
                                style: TextStyle(
                                  color: Colors.orangeAccent.shade100,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 12)
                            ],
                          ),
                          trailing: isEquipada
                              ? Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.orangeAccent.shade200, width: 1.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Equipada",
                                    style: TextStyle(
                                      color: Colors.orangeAccent.shade200,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orangeAccent.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    "Equipar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final ok = await armesProvider.equiparArma(
                                      usuariId: usuariId,
                                      skinId: skinId,
                                      armaId: arma.id,
                                    );
                                    provider.fetchPersonatgesAmbSkins(usuariId.toString());
                                    if (ok) {
                                      await skin.getSkinSeleccionada(usuariId);
                                      await MissionsLogic.completarMissioEquiparArma(context);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Arma equipada amb èxit!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Error en equipar l'arma."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 20),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.shade200,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "Tancar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
