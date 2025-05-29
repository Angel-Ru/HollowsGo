class Titol {
  final int id;
  final String nomTitol;

  Titol({required this.id, required this.nomTitol});

  factory Titol.fromJson(Map<String, dynamic> json) {
    return Titol(
      id: json['titol_id'],
      nomTitol: json['nom_titol'],
    );
  }
}
