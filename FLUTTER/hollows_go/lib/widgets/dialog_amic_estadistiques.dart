import 'package:flutter/material.dart';

class DialogAmicEstadistiques extends StatelessWidget {
  final String nom;
  final String? avatarUrl;
  final int partidesJugades;
  final int partidesGuanyades;
  final int nombrePersonatges;
  final int nombreSkins;

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
    return Dialog(
      backgroundColor: Colors.black,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orangeAccent, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Capçalera amb Avatar + dades
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar amb nivell
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                      child: avatarUrl == null
                          ? Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    if (nivell != null)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$nivell',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Estadístiques principals
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Primera línia
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🎮 $partidesJugades PJ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '🧙 $nombrePersonatges Pers.',
                            style: TextStyle(color: Colors.white),
                          ),
                          Flexible(
                            child: Text(
                              '⭐ $personatgePreferit',
                              style: TextStyle(
                                  color: Colors.orangeAccent,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Segona línia
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🏆 $partidesGuanyades PG',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '🎨 $nombreSkins Skins',
                            style: TextStyle(color: Colors.white),
                          ),
                          imatgeSkinPreferida != null
                              ? Image.network(
                                  imatgeSkinPreferida!,
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                )
                              : Text('💠 Cap skin',
                                  style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nom i títol
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    nomTitol,
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Botó de tancar
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Tancar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
