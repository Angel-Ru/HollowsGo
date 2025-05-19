class Skin {
  int id;
  String nom;
  int? categoria;
  String? imatge;
  int? puntsDonats;
  int? malTotal;
  String? personatgeNom;
  int? vida;
  int? currentHealth;
  String? atac;
  int? raca;

  Skin({
    required this.id,
    required this.nom,
    this.categoria,
    this.imatge,
    this.puntsDonats,
    this.malTotal,
    this.personatgeNom,
    this.vida,
    this.atac,
    this.raca,
  }) : currentHealth = vida ?? 0;

  factory Skin.fromJson(Map<String, dynamic> json) {
    int? parseNullableInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return Skin(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nom: json['nom'] ?? '',
      categoria: parseNullableInt(json['categoria']),
      imatge: json['imatge'],
      puntsDonats: parseNullableInt(json['punts_donats']),
      malTotal: parseNullableInt(json['mal_total']),
      personatgeNom: json['personatge_nom'],
      vida: parseNullableInt(json['vida']),
      atac: json['atac_nom'],
      raca: parseNullableInt(json['raça']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'categoria': categoria,
        'imatge': imatge,
        'punts_donats': puntsDonats,
        'mal_total': malTotal,
        'personatge_nom': personatgeNom,
        'vida': vida,
        'atac_nom': atac,
        'raça': raca,
      };
}