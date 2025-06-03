// Drawer complet
import '../../imports.dart';
import '../../models/missionArma.dart';
import '../../models/missionDiaria.dart';
import '../../models/missionTitol.dart';
import '../../providers/missions_provider.dart';

class MissionsDrawer extends StatefulWidget {
  final int usuariId;

  const MissionsDrawer({Key? key, required this.usuariId}) : super(key: key);

  @override
  _MissionsDrawerState createState() => _MissionsDrawerState();
}

class _MissionsDrawerState extends State<MissionsDrawer> {
  late Future<void> _loadFutures;

  @override
  void initState() {
    super.initState();
    final missionsProvider = Provider.of<MissionsProvider>(context, listen: false);
   
    _loadFutures = Future.wait([
      
      missionsProvider.fetchMissions(widget.usuariId),
      missionsProvider.fetchMissioTitol(widget.usuariId),
      missionsProvider.fetchMissioArma(widget.usuariId)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final missionsProvider = Provider.of<MissionsProvider>(context);
    final missions = missionsProvider.missions;
    final missioTitol = missionsProvider.missioTitol;
    final missioArma = missionsProvider.missioArma;

    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text(
                'Missions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Divider(color: Colors.grey[800]),

            Expanded(
              child: FutureBuilder(
                future: _loadFutures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error carregant missions',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Missions Diaries
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

                            const SizedBox(height: 24),

                            // Missió Títol
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Missió Títol',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent[200],
                                ),
                              ),
                            ),
                            missioTitol != null
                                ? _buildMissioTitolCard(missioTitol)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    child: Text(
                                      'No hi ha missió de títol activa.',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),

                            const SizedBox(height: 24),

                            // Missió Arma
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'Missió Arma',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent[200],
                                ),
                              ),
                            ),
                            missioArma != null
                                ? _buildMissioArmaCard(missioArma)
                                : Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    child: Text(
                                      'No hi ha missió d\'arma activa.',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                          ],
                        ),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            missio.nom,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            missio.descripcio,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: missio.objectiu > 0 ? missio.progress / missio.objectiu : 0,
              minHeight: 10,
              backgroundColor: Colors.grey[800],
              color: Colors.orangeAccent[400],
            ),
          ),
          const SizedBox(height: 6),
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
          colors: [Colors.grey.shade900, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[300], size: 28),
              const SizedBox(width: 8),
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
          const SizedBox(height: 4),
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
          Text(
            missioTitol.nomMissio,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            missioTitol.descripcio,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: missioTitol.objectiu > 0 ? missioTitol.progres / missioTitol.objectiu : 0,
              minHeight: 12,
              backgroundColor: Colors.grey[700],
              color: Colors.orangeAccent[100],
            ),
          ),
          const SizedBox(height: 6),
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

  Widget _buildMissioArmaCard(MissionArma missioArma) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, Colors.blueGrey.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.cyan[200], size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Arma associada:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyan[100],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            missioArma.nomArma,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.cyan[100],
              letterSpacing: 0.6,
            ),
          ),
          Divider(color: Colors.cyan[300], thickness: 1.2, height: 24),
          Text(
            missioArma.nomMissio,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            missioArma.descripcio,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: missioArma.objectiu > 0 ? missioArma.progres / missioArma.objectiu : 0,
              minHeight: 12,
              backgroundColor: Colors.blueGrey[700],
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${missioArma.progres}/${missioArma.objectiu} completat',
            style: TextStyle(
              fontSize: 14,
              color: Colors.cyan[200],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
