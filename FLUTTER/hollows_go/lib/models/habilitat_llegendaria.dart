// models/habilitat_llegendaria.dart
class HabilitatLlegendaria {
  final int id;
  final String nom;
  final String descripcio;
  final int skinPersonatge;
  final String efecte;

  HabilitatLlegendaria({
    required this.id,
    required this.nom,
    required this.descripcio,
    required this.skinPersonatge,
    required this.efecte,
  });

  factory HabilitatLlegendaria.fromJson(Map<String, dynamic> json) {
    return HabilitatLlegendaria(
      id: json['id'],
      nom: json['nom'],
      descripcio: json['descripcio'],
      skinPersonatge: json['skin_personatge'],
      efecte: json['efecte'],
    );
  }
}
