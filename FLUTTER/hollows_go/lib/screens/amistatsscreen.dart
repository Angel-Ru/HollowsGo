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
    _refreshAmistats();
  }

  void _refreshAmistats() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _amistatsFuture = userProvider.fetchAmistatsUsuari();
    if (mounted) setState(() {});
  }

  Future<void> _acceptarAmistat(int friendId, String friendName) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final acceptat = await userProvider.acceptarAmistat(friendId);

    if (acceptat && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Has acceptat la sol·licitud de $friendName'),
          backgroundColor: Colors.green,
        ),
      );
      _refreshAmistats();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al acceptar la sol·licitud'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            return const Center(child: Text('Encara no tens cap amistat.'));
          }

          return ListView.builder(
            itemCount: amistats.length,
            itemBuilder: (context, index) {
              final amistat = amistats[index];
              final nom = amistat['nom_amic'] ?? 'Desconegut';
              final estat = amistat['estat'] ?? 'Desconegut';
              final friendId = amistat['id_amic'] ?? 0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(nom),
                  subtitle: Text('Estat: ${_capitalize(estat)}'),
                  trailing: _buildActionButtons(estat, friendId, nom),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildActionButtons(String estat, int friendId, String friendName) {
    switch (estat) {
      case 'pendent':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => _acceptarAmistat(friendId, friendName),
              tooltip: 'Acceptar',
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {}, // Aquí podries afegir la lògica per rebutjar
              tooltip: 'Rebutjar',
            ),
          ],
        );
      case 'acceptat':
        return const Icon(Icons.verified, color: Colors.green);
      case 'rebutjat':
        return const Icon(Icons.block, color: Colors.red);
      default:
        return const SizedBox.shrink();
    }
  }
}
