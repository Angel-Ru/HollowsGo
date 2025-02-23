// To parse this JSON data, do
//
//     final skin = skinFromJson(jsonString);

import 'dart:convert';

Skin skinFromJson(String str) => Skin.fromJson(json.decode(str));

String skinToJson(Skin data) => json.encode(data.toJson());

class Skin {
    SkinClass skin;

    Skin({
        required this.skin,
    });

    factory Skin.fromJson(Map<String, dynamic> json) => Skin(
        skin: SkinClass.fromJson(json["skin"]),
    );

    Map<String, dynamic> toJson() => {
        "skin": skin.toJson(),
    };
}

class SkinClass {
    int id;
    String nom;
    int categoria;
    String imatge;
    int puntsDonats;
    int malTotal;
    String personatgeNom;
    int vida;
    int currentHealth;

    SkinClass({
        required this.id,
        required this.nom,
        required this.categoria,
        required this.imatge,
        required this.puntsDonats,
        required this.malTotal,
        required this.personatgeNom,
        required this.vida,
    }): currentHealth = vida;

    factory SkinClass.fromJson(Map<String, dynamic> json) => SkinClass(
        id: json["id"],
        nom: json["nom"],
        categoria: json["categoria"],
        imatge: json["imatge"],
        puntsDonats: json["punts_donats"],
        malTotal: json["mal_total"],
        personatgeNom: json["personatge_nom"],
        vida: json["vida"],
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
    };
}