import 'package:flutter/material.dart';

class DialogAmicEstadistiques extends StatelessWidget {
  final String nom;
  final String? avatarUrl;
  final int partidesJugades;
  final int partidesGuanyades;
  final int nombrePersonatges;
  final int nombreSkins;

  const DialogAmicEstadistiques({
    Key? key,
    required this.nom,
    this.avatarUrl,
    required this.partidesJugades,
    required this.partidesGuanyades,
    required this.nombrePersonatges,
    required this.nombreSkins,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? Icon(Icons.person, size: 28) : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              nom,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎮 Partides Jugades: $partidesJugades'),
          Text('🏆 Partides Guanyades: $partidesGuanyades'),
          SizedBox(height: 8),
          Text('🧙 Personatges Obtinguts: $nombrePersonatges'),
          Text('🎨 Skins Obtingudes: $nombreSkins'),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Tancar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
