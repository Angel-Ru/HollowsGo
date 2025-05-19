import 'package:hollows_go/models/skin.dart';

class Personatge {
  int id;
  String nom;
  int? vidaBase;
  int? malBase;
  List<Skin> skins;
  String? classe;
  String? descripcio;
  int? altura;
  double? pes;
  String? genere;
  DateTime? aniversari;

  Personatge({
    required this.id,
    required this.nom,
    this.vidaBase,
    this.malBase,
    this.classe,
    this.descripcio,
    this.altura,
    this.pes,
    this.genere,
    this.aniversari,
    required this.skins,
  });

  factory Personatge.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      if (value is DateTime) return value.day;
      return 0;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return Personatge(
      id: parseInt(json['id']),
      nom: json['nom'] ?? '',
      vidaBase: parseInt(json['vida_base']),
      malBase: parseInt(json['mal_base']),
      classe: json['Classe']?.toString(),
      descripcio: json['descripcio']?.toString(),
      altura: parseInt(json['altura']),
      pes: parseDouble(json['pes']),
      genere: json['Genere']?.toString(),
      aniversari: json['aniversari'] != null
          ? DateTime.tryParse(json['aniversari'])
          : null,
      skins: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personatge_id': id,
      'personatge_nom': nom,
      'vida_base': vidaBase,
      'mal_base': malBase,
      'Classe': classe,
      'descripcio': descripcio,
      'altura': altura,
      'pes': pes,
      'Genere': genere,
      'aniversari': aniversari?.toIso8601String(),
      'skins': skins.map((skin) => skin.toJson()).toList(),
    };
  }
}
