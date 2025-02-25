import 'package:hollows_go/models/skin.dart';

class Personatge {
  int id;
  String nom;
  int? vidaBase;
  int? malBase;
  List<Skin> skins;

  Personatge({
    required this.id,
    required this.nom,
    this.vidaBase,
    this.malBase,
    required this.skins,
  });

  factory Personatge.fromJson(Map<String, dynamic> json) {
    return Personatge(
      id: json['id'],
      nom: json['nom'],
      vidaBase: json['vida_base'],
      malBase: json['mal_base'],
      skins: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'vida_base': vidaBase,
      'mal_base': malBase,
      'skins': skins.map((skin) => skin.toJson()).toList(),
    };
  }
}
