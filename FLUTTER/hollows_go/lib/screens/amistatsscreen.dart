import '../imports.dart';

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
    _refreshAmistats();
  }

  void _refreshAmistats() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _amistatsFuture = userProvider.fetchAmistatsUsuari();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Les meves amistats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAmistats,
          ),
        ],
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
            return const Center(
              child: Text('No hi ha amistats disponibles.'),
            );
          }

          return ListView.builder(
            itemCount: amistats.length,
            itemBuilder: (context, index) {
              final amistat = amistats[index];
              final nom = amistat['nom_amic'] ?? 'Desconegut';
              final estat = amistat['estat'] ?? 'desconegut';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(nom),
                  subtitle: Text('Estat: ${estat.toUpperCase()}'),
                  trailing: _estatBadge(estat),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _estatBadge(String estat) {
    Color color;
    switch (estat.toLowerCase()) {
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
        color = Colors.grey;
    }

    return Chip(
      label: Text(estat.toUpperCase()),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }
}
