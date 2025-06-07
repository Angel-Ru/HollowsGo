class MissionTitol {
  final int titolId;           // ID del títol
  final String nomTitol;       // Nom del títol
  final int id;                // ID de la missió
  final String nomMissio;      // Nom de la missió
  final String descripcio;     // Descripció de la missió
  final int objectiu;          // Objectiu de la missió
  final int progres;           // Progrés actual de la missió

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
    final missio = json['missio'] ?? {};

    return MissionTitol(
      titolId: json['titol_id'] ?? 0,
      nomTitol: json['nom_titol'] ?? '',
      id: missio['id'] ?? 0,
      nomMissio: missio['nom_missio'] ?? '',
      descripcio: missio['descripcio'] ?? '',
      objectiu: missio['objectiu'] ?? 0,
      progres: missio['progres'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Títol: $nomTitol (ID: $titolId), Missió: $nomMissio (ID: $id), Objectiu: $objectiu, Progrés: $progres';
  }
}
