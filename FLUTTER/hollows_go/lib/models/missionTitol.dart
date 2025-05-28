class MissionTitol {
  final int titolId;
  final String nomTitol;
  final int id;
  final String nomMissio;
  final String descripcio;
  final int objectiu;
  final int progres;

  MissionTitol({
    required this.titolId,
    required this.nomTitol,
    required this.id,
    required this.nomMissio,
    required this.descripcio,
    required this.objectiu,
    required this.progres,
  });

  factory MissionTitol.fromJson(Map<String, dynamic> json) {
    final missio = json['missio'];
    return MissionTitol(
      titolId: json['titol_id'],
      nomTitol: json['nom_titol'],
      id: missio['id'],
      nomMissio: missio['nom_missio'],
      descripcio: missio['descripcio'],
      objectiu: missio['objectiu'],
      progres: missio['progres'],
    );
  }
}
