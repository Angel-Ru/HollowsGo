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

  Skin(
      {required this.id,
      required this.nom,
      this.categoria,
      this.imatge,
      this.puntsDonats,
      this.malTotal,
      this.personatgeNom,
      this.vida,
      this.atac})
      : currentHealth = vida ?? 0;

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
      id: json["id"],
      nom: json["nom"],
      categoria: json["categoria"],
      imatge: json["imatge"],
      puntsDonats: json["punts_donats"],
      malTotal: json["mal_total"],
      personatgeNom: json["personatge_nom"],
      vida: json["vida"],
      atac: json["atac_nom"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "categoria": categoria,
        "imatge": imatge,
        "punts_donats": puntsDonats,
        "mal_total": malTotal,
        "personatge_nom": personatgeNom,
        "vida": vida,
        "atac_nom": atac,
      };
}
