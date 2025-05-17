class Arma {
  final int id;
  final String nom;
  final int categoria;
  final int buffAtac;

  Arma({
    required this.id,
    required this.nom,
    required this.categoria,
    required this.buffAtac,
  });

  factory Arma.fromJson(Map<String, dynamic> json) {
    return Arma(
      id: json['id'],
      nom: json['nom'],
      categoria: json['categoria'],
      buffAtac: json['buff_atac'],
    );
  }
}
