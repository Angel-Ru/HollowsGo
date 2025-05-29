class MissionArma {
  final String nomArma;
  final int id;
  final String nomMissio;
  final String descripcio;
  final int objectiu;
  final int progres;

  MissionArma({
    required this.nomArma,
    required this.id,
    required this.nomMissio,
    required this.descripcio,
    required this.objectiu,
    required this.progres,
  });

  factory MissionArma.fromJson(Map<String, dynamic> json) {
    final missio = json['missio'] ?? {};
    return MissionArma(
      nomArma: json['arma'],
      id: missio['id'],
      nomMissio: missio['nom_missio'],
      descripcio: missio['descripcio'],
      objectiu: missio['objectiu'] ?? 1,
      progres: missio['progres'] ?? 0,
    );
  }
}
