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

