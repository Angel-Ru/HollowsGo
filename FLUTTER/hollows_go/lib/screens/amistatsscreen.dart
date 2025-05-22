import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AmistatsScreen extends StatefulWidget {
  const AmistatsScreen({Key? key}) : super(key: key);

  @override
  State<AmistatsScreen> createState() => _AmistatsScreenState();
}

class _AmistatsScreenState extends State<AmistatsScreen> {
  late Future<List<Map<String, dynamic>>> _amistatsFuture;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _amistatsFuture = userProvider.fetchAmistatsPendentsUsuari();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Les meves amistats'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _amistatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error carregant les amistats.'));
          }

          final amistats = snapshot.data ?? [];

          if (amistats.isEmpty) {
            return const Center(child: Text('Encara no tens cap amistat.'));
          }

          return ListView.builder(
            itemCount: amistats.length,
            itemBuilder: (context, index) {
              final amistat = amistats[index];
              final nom = amistat['nom_amic'] ?? 'Desconegut';
              final estat = amistat['estat'] ?? 'Desconegut';

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(nom),
                subtitle: Text('Estat: $estat'),
                trailing: _estatBadge(estat),
              );
            },
          );
        },
      ),
    );
  }

  // Widget per mostrar un badge segons l'estat
  Widget _estatBadge(String estat) {
    Color color;
    switch (estat) {
      case 'acceptat':
        color = Colors.green;
        break;
      case 'pendent':
        color = Colors.orange;
        break;
      case 'rebutjat':
        color = Colors.red;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estat,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
