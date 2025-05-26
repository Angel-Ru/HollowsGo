import 'dart:ui';

import 'package:hollows_go/widgets/dialogue_amic.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('Orihime');
    });
  }

  void _refreshAmistats() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _amistatsFuture = userProvider.fetchAmistatsUsuari();
    if (mounted) setState(() {});
  }

  void _showAfegirAmicDialog() {
    showDialog(
      context: context,
      builder: (context) => AfegirAmicDialog(
        onAmicAfegit: _refreshAmistats,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.5),
              elevation: 0,
              title: null,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/amistats_fondo.png'), // Asegúrate de tener esta imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          // Contenido principal
          Column(
            children: [
              // Barra de título con acciones
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                      Text(
                        'Les meves amistats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.refresh, color: Colors.white),
                            onPressed: _refreshAmistats,
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: _showAfegirAmicDialog,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de amigos
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _amistatsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.pink),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error carregant les amistats.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final amistats = snapshot.data ?? [];

                    if (amistats.isEmpty) {
                      return Center(
                        child: Text(
                          'No hi ha amistats disponibles.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.builder(
                        itemCount: amistats.length,
                        itemBuilder: (context, index) {
                          final amistat = amistats[index];
                          final nom = amistat['nom_amic'] ?? 'Desconegut';
                          final estat = amistat['estat'] ?? 'desconegut';

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: Colors.black.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.pink.withOpacity(0.3),
                                child: Icon(Icons.book, color: Colors.white),
                              ),
                              title: Text(
                                nom,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Estat: ${estat.toUpperCase()}',
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: _estatBadge(estat),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Diálogo al final
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DialogueWidget(
                characterName: 'Inoue Orihime',
                nameColor: Colors.pink,
                bubbleColor: Color.fromARGB(212, 238, 238, 238),
              ),
            ),
          ),
        ],
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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        estat.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
