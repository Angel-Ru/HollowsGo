import 'package:hollows_go/imports.dart';
import 'package:hollows_go/providers/equipament_provider.dart';

Future<void> mostrarDialegArmesPredefinides({
  required BuildContext context,
  required int skinId,
  required int usuariId,
  required ArmesProvider armesProvider,
}) async {
  await armesProvider.fetchArmesPerSkin(skinId);
  final provider =
      Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.black.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg',
              ),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.8), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Selecciona una arma",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade300,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                          subtitle: Text(
                            'Categoria: ${arma.categoria} - +${arma.buffAtac} ATK',
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: ElevatedButton(
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
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Arma equipada amb èxit!"),
                                      backgroundColor: Colors.green),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Error en equipar l'arma."),
                                      backgroundColor: Colors.red),
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
