import 'package:flutter/material.dart';

class DialogAmicEstadistiques extends StatelessWidget {
  final String nom;
  final String? avatarUrl;
  final int partidesJugades;
  final int partidesGuanyades;
  final int nombrePersonatges;
  final int nombreSkins;

  // Nous camps
  final String personatgePreferit;
  final String? imatgeSkinPreferida;
  final int? nivell;
  final String nomTitol;

  const DialogAmicEstadistiques({
    Key? key,
    required this.nom,
    this.avatarUrl,
    required this.partidesJugades,
    required this.partidesGuanyades,
    required this.nombrePersonatges,
    required this.nombreSkins,
    required this.personatgePreferit,
    this.imatgeSkinPreferida,
    this.nivell,
    required this.nomTitol,
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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎮 Partides Jugades: $partidesJugades'),
            Text('🏆 Partides Guanyades: $partidesGuanyades'),
            SizedBox(height: 8),
            Text('🧙 Personatges Obtinguts: $nombrePersonatges'),
            Text('🎨 Skins Obtingudes: $nombreSkins'),
            SizedBox(height: 12),
            Text('⭐ Personatge Preferit: $personatgePreferit'),
            if (imatgeSkinPreferida != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.network(imatgeSkinPreferida!, height: 80),
              ),
            if (nivell != null) Text('📊 Nivell: $nivell'),
            Text('🏅 Títol equipat: $nomTitol'),
          ],
        ),
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
