import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

// Model bàsic per la missió (ajusta segons la resposta real)
class MissionDiary {
  final int id;
  final int usuari;
  final int missio;
  final String dataAssign;
  final String nom;
  final String descripcio;

  MissionDiary({
    required this.id,
    required this.usuari,
    required this.missio,
    required this.dataAssign,
    required this.nom,
    required this.descripcio,
  });

  factory MissionDiary.fromJson(Map<String, dynamic> json) {
    return MissionDiary(
      id: json['id'],
      usuari: json['usuari'],
      missio: json['missio'],
      dataAssign: json['data_assign'],
      nom: json['nom'],
      descripcio: json['descripcio'],
    );
  }
}

class MissionsDrawer extends StatefulWidget {
  final int usuariId;

  const MissionsDrawer({Key? key, required this.usuariId}) : super(key: key);

  @override
  _MissionsDrawerState createState() => _MissionsDrawerState();
}

class _MissionsDrawerState extends State<MissionsDrawer> {
  late Future<List<MissionDiary>> missionsFuture;

  @override
  void initState() {
    super.initState();
    missionsFuture = fetchMissions(widget.usuariId);
  }

  Future<List<MissionDiary>> fetchMissions(int usuariId) async {
    final url = Uri.parse('https://${Config.ip}/missions/diaries/$usuariId'); 
    
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List missionsJson = data['missions'] ?? [];

      return missionsJson.map((json) => MissionDiary.fromJson(json)).toList();
    } else {
      throw Exception('Error carregant missions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text('Missions Diaries', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder<List<MissionDiary>>(
                future: missionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error carregant missions'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hi ha missions assignades'));
                  }

                  final missions = snapshot.data!;

                  return ListView.builder(
                    itemCount: missions.length,
                    itemBuilder: (context, index) {
                      final missio = missions[index];
                      return ListTile(
                        leading: Icon(Icons.task_alt),
                        title: Text(missio.nom),
                        subtitle: Text(missio.descripcio),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
