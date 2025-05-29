import '../../../imports.dart';
import 'package:provider/provider.dart';

import '../../models/titol.dart';

class PerfilHeader extends StatelessWidget {
  final String username;
  final int userId;
  final String? titolUsuari; // Nou camp per passar el nom del títol

  const PerfilHeader({
    Key? key,
    required this.username,
    required this.userId,
    this.titolUsuari,
  }) : super(key: key);

  void _mostrarDialegTitols(BuildContext context) async {
    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);

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
                stops: [0.75, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade300.withOpacity(0.8), width: 1),
            ),
            child: FutureBuilder<List<Titol>>(
              future: perfilProvider.fetchTitolsComplets(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Error al carregar els títols.",
                        style: TextStyle(
                          color: Colors.redAccent.shade100,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
                        child: const Text(
                          "Tancar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  final titols = snapshot.data ?? [];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Títols disponibles",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade300,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (titols.isEmpty)
                        const Text(
                          "No hi ha títols disponibles.",
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
                            itemCount: titols.length,
                            itemBuilder: (context, index) {
                              final titol = titols[index];
                              return Card(
                                color: Colors.black.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.orange.shade300, width: 1),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Icon(Icons.military_tech_sharp, color: Colors.amber.shade300),
                                  title: Text(
                                    titol.nomTitol,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
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
                        child: const Text(
                          "Tancar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          username,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titolUsuari ?? 'Sense títol',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _mostrarDialegTitols(context),
              child: const Icon(
                Icons.edit,
                size: 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
