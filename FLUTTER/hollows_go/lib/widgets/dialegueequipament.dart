import 'package:hollows_go/imports.dart';
import 'package:hollows_go/providers/equipament_provider.dart';

Future<void> mostrarDialegArmesPredefinides({
  required BuildContext context,
  required int skinId,
  required int usuariId,
  required ArmesProvider armesProvider,
}) async {
  await armesProvider.fetchArmesPerSkin(skinId);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Selecciona una arma"),
        content: armesProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : armesProvider.armesDisponibles.isEmpty
                ? Text("No hi ha armes disponibles.")
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: armesProvider.armesDisponibles.map((arma) {
                      return ListTile(
                        title: Text('${arma.nom}'),
                        subtitle: Text('Categoria: ${arma.categoria} - +${arma.buffAtac} ATK'),
                        trailing: ElevatedButton(
                          child: Text("Equipar"),
                          onPressed: () async {
                            final ok = await armesProvider.equiparArma(
                              usuariId: usuariId,
                              skinId: skinId,
                              armaId: arma.id,
                            );
                            if (ok) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Arma equipada amb èxit!")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error en equipar l'arma.")),
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
        actions: [
          TextButton(
            child: Text("Tancar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
