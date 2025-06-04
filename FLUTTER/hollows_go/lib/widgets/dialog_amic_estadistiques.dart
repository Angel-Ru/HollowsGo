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
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.orangeAccent.withOpacity(0.8), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar centrat a dalt
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black.withOpacity(0.3),
                  backgroundImage:
                      avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? Icon(Icons.person,
                          size: 50, color: Colors.white.withOpacity(0.8))
                      : null,
                ),
                if (nivell != null)
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.9),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.black.withOpacity(0.7), width: 2),
                    ),
                    child: Text(
                      nivell.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 10),

            // Nom de l'usuari
            Text(
              nom,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Títol de l'usuari
            Text(
              nomTitol,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orangeAccent.withOpacity(0.9),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 20),

            // Primera fila d'estadístiques
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                    label: 'P. jugades:', value: partidesJugades.toString()),
                _buildStatItem(
                    label: 'P. guanyades:',
                    value: partidesGuanyades.toString()),
                _buildStatItem(
                    label: 'Per. Obtinguts:',
                    value: nombrePersonatges.toString()),
                _buildStatItem(
                    label: 'Skins Obtingudes:', value: nombreSkins.toString()),
              ],
            ),

            SizedBox(height: 20),

            // Tercera fila (personatge i skin preferits)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Personatge preferit
                Column(
                  children: [
                    Text(
                      'Per. Preferit:',
                      style: TextStyle(
                        color: Colors.orangeAccent.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      personatgePreferit,
                      style: TextStyle(
                        color: Colors.orangeAccent.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Skin preferida
                Column(
                  children: [
                    Text(
                      'Skin preferida:',
                      style: TextStyle(
                        color: Colors.orangeAccent.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    imatgeSkinPreferida != null
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black.withOpacity(0.3),
                            ),
                            child: Image.network(
                              imatgeSkinPreferida!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            '-',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            // Botó de tancar
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                      color: Colors.orangeAccent.withOpacity(0.7), width: 1),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tancar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.orangeAccent.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
