class Skin {
  int id;
  String nom;
  int? categoria;       // Pot ser null
  String? imatge;       // Pot ser null
  int? puntsDonats;     // Pot ser null
  int? malTotal;        // Pot ser null
  String? personatgeNom; // Pot ser null
  int? vida;            // Pot ser null
  int? currentHealth;
  String? atac;

  Skin({
    required this.id,
    required this.nom,
    this.categoria,
    this.imatge,
    this.puntsDonats,
    this.malTotal,
    this.personatgeNom,
    this.vida,
    this.atac
  }) : currentHealth = vida ?? 0; // Si vida és null, currentHealth serà 0

  factory Skin.fromJson(Map<String, dynamic> json) => Skin(
        id: json["id"],
        nom: json["nom"],
        categoria: json["categoria"], // Pot ser null
        imatge: json["imatge"],       // Pot ser null
        puntsDonats: json["punts_donats"], // Pot ser null
        malTotal: json["mal_total"],       // Pot ser null
        personatgeNom: json["personatge_nom"], // Pot ser null
        vida: json["vida"],
        atac: json["atac_nom"]                   // Pot ser null
      );

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