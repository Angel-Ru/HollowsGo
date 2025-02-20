import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    UserClass user;

    User({
        required this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
    };
}

class UserClass {
    String nom;
    String email;
    int puntsEmmagatzemats;
    int tipo;

    UserClass({
        required this.nom,
        required this.email,
        required this.puntsEmmagatzemats,
        required this.tipo,
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        nom: json["nom"],
        email: json["email"],
        puntsEmmagatzemats: json["punts_emmagatzemats"],
        tipo: json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "nom": nom,
        "email": email,
        "punts_emmagatzemats": puntsEmmagatzemats,
        "tipo": tipo,
    };
}