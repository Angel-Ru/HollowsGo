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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Columna esquerra amb avatar i info usuari
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Avatar amb nivell
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black.withOpacity(0.3),
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl!)
                              : null,
                          child: avatarUrl == null
                              ? Icon(Icons.person,
                                  size: 50,
                                  color: Colors.white.withOpacity(0.8))
                              : null,
                        ),
                        if (nivell != null)
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.9),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.7),
                                  width: 2),
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
                  ],
                ),

                SizedBox(width: 20),

                // Columna dreta amb estadístiques
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Primera fila d'estadístiques
                      _buildStatRow(
                        label1: 'Partides jugades:',
                        value1: partidesJugades.toString(),
                        label2: 'Personatges obtinguts:',
                        value2: nombrePersonatges.toString(),
                        label3: 'Personatge preferit:',
                        value3: personatgePreferit,
                        isHighlighted: true,
                      ),
                      SizedBox(height: 16),
                      // Segona fila d'estadístiques
                      _buildStatRow(
                        label1: 'Partides guanyades:',
                        value1: partidesGuanyades.toString(),
                        label2: 'Skins obtingudes:',
                        value2: nombreSkins.toString(),
                        label3: 'Skin preferida:',
                        value3: '',
                        isHighlighted: false,
                        customWidget: imatgeSkinPreferida != null
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: Image.network(
                                  imatgeSkinPreferida!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Botó de tancar
            Align(
              alignment: Alignment.center,
              child: TextButton(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required String label1,
    required String value1,
    required String label2,
    required String value2,
    required String label3,
    required String value3,
    required bool isHighlighted,
    Widget? customWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Columna 1
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Columna 2
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        // Columna 3
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orangeAccent.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              if (customWidget != null)
                Center(child: customWidget)
              else
                Text(
                  value3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isHighlighted
                        ? Colors.orangeAccent.withOpacity(0.9)
                        : Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight:
                        isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
