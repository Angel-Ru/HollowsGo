import '../imports.dart';
import '../providers/missions_provider.dart';

class MissionDiary {
  final int id;
  final int usuari;
  final int missio;
  final String dataAssign;
  final String nom;
  final String descripcio;
  final int progress;
  final int objectiu;

  MissionDiary({
    required this.id,
    required this.usuari,
    required this.missio,
    required this.dataAssign,
    required this.nom,
    required this.descripcio,
    required this.progress,
    required this.objectiu,
  });

  factory MissionDiary.fromJson(Map<String, dynamic> json) {
    return MissionDiary(
      id: json['id'],
      usuari: json['usuari'],
      missio: json['missio'],
      dataAssign: json['data_assig'],
      nom: json['nom_missio'],
      descripcio: json['descripcio'],
      progress: json['progress'] ?? 0,
      objectiu: json['objectiu'] ?? 1,
    );
  }
}

class MissionsDrawer extends StatelessWidget {
  final int usuariId;

  const MissionsDrawer({Key? key, required this.usuariId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final missions = missionsProvider.missions;

    return Drawer(
      backgroundColor: const Color(0xFF121212), // Gris fosc en lloc de negre
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Missions Diaries',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Divider(color: Colors.grey[800]),
            Expanded(
              child: missions.isEmpty
                  ? FutureBuilder(
                      future: missionsProvider.fetchMissions(usuariId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: Colors.tealAccent));
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error carregant missions', style: TextStyle(color: Colors.redAccent)));
                        } else {
                          return _buildMissionList(missions);
                        }
                      },
                    )
                  : _buildMissionList(missions),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionList(List<MissionDiary> missions) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final missio = missions[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                missio.nom,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                missio.descripcio,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: missio.objectiu > 0 ? missio.progress / missio.objectiu : 0,
                  minHeight: 10,
                  backgroundColor: Colors.grey[800],
                  color: Colors.orangeAccent[400],
                ),
              ),
              SizedBox(height: 6),
              Text(
                '${missio.progress}/${missio.objectiu} completat',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
