import '../imports.dart';
import '../providers/missions_provider.dart';
import 'missionTitol.dart';

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
    final missioTitol = missionsProvider.missioTitol;

    return Drawer(
      backgroundColor: const Color(0xFF121212),
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
              child: FutureBuilder(
                future: missionsProvider.assignarIObtenirTitol(usuariId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.tealAccent));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error carregant missions', style: TextStyle(color: Colors.redAccent)));
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Missions Diaries
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            child: Text(
                              'Missions Diaries',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          if (missions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'No hi ha missions diaries disponibles.',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          else
                            ...missions.map((missio) => _buildMissionCard(missio)).toList(),

                          SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Divider(color: Colors.grey[700]),
                          ),

                          // Missió Títol
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            child: Text(
                              'Missió de Títol',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent[400],
                              ),
                            ),
                          ),

                          if (missioTitol != null)
                            _buildMissioTitolCard(missioTitol)
                          else
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'No hi ha missió de títol activa.',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),

                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard(MissionDiary missio) {
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
  }

  Widget _buildMissioTitolCard(MissionTitol missioTitol) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.deepOrange.shade800, Colors.deepOrange.shade900],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Títol destacat
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber[300], size: 28),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Títol que aconseguiràs:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange[100],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          missioTitol.nomTitol,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.amber[200],
            letterSpacing: 0.8,
          ),
        ),
        Divider(color: Colors.orange[300], thickness: 1.2, height: 24),

        // Nom i descripció de la missió
        Text(
          missioTitol.nomMissio,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          missioTitol.descripcio,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        SizedBox(height: 16),

        // Barra de progrés
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: missioTitol.objectiu > 0
                ? missioTitol.progres / missioTitol.objectiu
                : 0,
            minHeight: 12,
            backgroundColor: Colors.orange[800],
            color: Colors.orangeAccent[100],
          ),
        ),
        SizedBox(height: 6),
        Text(
          '${missioTitol.progres}/${missioTitol.objectiu} completat',
          style: TextStyle(
            fontSize: 14,
            color: Colors.orange[100],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

}
