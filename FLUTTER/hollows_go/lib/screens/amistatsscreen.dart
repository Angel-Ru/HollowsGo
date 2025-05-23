import '../imports.dart';

class AmistatsScreen extends StatefulWidget {
  const AmistatsScreen({Key? key}) : super(key: key);

  @override
  State<AmistatsScreen> createState() => _AmistatsScreenState();
}

class _AmistatsScreenState extends State<AmistatsScreen> {
  late Future<List<Map<String, dynamic>>> _amistatsFuture;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _refreshAmistats();
  }

  void _refreshAmistats() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_selectedTab == 0) {
      _amistatsFuture = userProvider.fetchAmistatsUsuari();
    } else {
      _amistatsFuture = userProvider.fetchAmistatsPendents();
    }
    if (mounted) setState(() {});
  }

  Future<void> _acceptarAmistat(int amistatId, String nomAmic) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final acceptat = await userProvider.acceptarAmistat(amistatId);

      if (acceptat && mounted) {
        _showSnackBar('Has acceptat la sol·licitud de $nomAmic');
        _refreshAmistats();
      } else if (mounted) {
        _showSnackBar('Error al acceptar la sol·licitud', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: ${e.toString()}', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _selectedTab,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Les meves amistats'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshAmistats,
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index;
                _refreshAmistats();
              });
            },
            tabs: const [
              Tab(text: 'Totes'),
              Tab(text: 'Pendents'),
            ],
          ),
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
                final amistatId = amistat['id'] ?? 0;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(nom),
                    subtitle: Text('Estat: ${estat.toUpperCase()}'),
                    trailing: estat == 'pendent'
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check,
                                    color: Colors.green),
                                onPressed: () =>
                                    _acceptarAmistat(amistatId, nom),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  // Aquí pots implementar la funcionalitat per rebutjar amistat
                                },
                              ),
                            ],
                          )
                        : _estatBadge(estat),
                  ),
                );
              },
            );
          },
        ),
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
