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
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Personatge(
      id: parseInt(json['id']),
      nom: json['nom'] ?? '',
      vidaBase: parseInt(json['vida_base']),
      malBase: parseInt(json['mal_base']),
      skins: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personatge_id': id,
      'personatge_nom': nom,
      'vida_base': vidaBase,
      'mal_base': malBase,
      'skins': skins.map((skin) => skin.toJson()).toList(),
    };
  }
}
