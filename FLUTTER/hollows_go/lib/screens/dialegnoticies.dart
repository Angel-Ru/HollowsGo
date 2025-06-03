import 'package:flutter/material.dart';

class DialegNoticies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Novetats',
            style: TextStyle(
              color: Colors.amberAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📢 Versió 1.0 de "HollowsGO:Remastered" ja disponible!\n Actualització ambientada en l\'arc més recent de l\'Anime\n El Thousand Year Blood War.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'lib/images/prehomescreen_images/HollowsGo_Remastered_LOGO.png',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '💡 Nous Personatge:\n Afegits un total de 33 personatges nous i un total de  la raça dels Quincies, d’afrontar enemics de nivell alt. Consulta la secció de “Tàctiques” per més informació.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ Properament...\nEstem preparant una nova zona de joc ambientada en el món dels Vizards. Estigues atent a les pròximes actualitzacions!',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tancar',
                style: TextStyle(color: Colors.amberAccent),
              ),
            ),
          )
        ],
      ),
    );
  }
}
