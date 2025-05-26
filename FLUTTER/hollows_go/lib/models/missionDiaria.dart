import '../imports.dart';
import '../providers/missions_provider.dart'; // Assegura't que tens la IP definida a config.dart

// Model bàsic per la missió (ajustat amb progress i objectiu)
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
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Missions Diaries',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Divider(),
            Expanded(
              child: missions.isEmpty
                  ? FutureBuilder(
                      future: missionsProvider.fetchMissions(usuariId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error carregant missions'));
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
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(missio.nom,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 4),
                Text(missio.descripcio),
                SizedBox(height: 12),
                LinearProgressIndicator(
                  value: missio.objectiu > 0
                      ? missio.progress / missio.objectiu
                      : 0,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.blue,
                ),
                SizedBox(height: 6),
                Text(
                  '${missio.progress}/${missio.objectiu} completat',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
