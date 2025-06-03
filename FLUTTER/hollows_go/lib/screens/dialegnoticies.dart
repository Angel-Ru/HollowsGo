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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '📢 ·Versió 1.0 de "HollowsGO:Remastered"\n ja disponible!\n Actualització ambientada en l\'arc més recent de l\'Anime\n El Thousand Year Blood War.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'lib/images/prehomescreen_images/HollowsGo_Remastered_LOGO.png',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '💡 ·Nous Personatges·\n Afegits un total de 33 personatges nous i un total de 74 skins noves, afegint-hi la raça dels Quincies i fent jugables als Hollows i a Quincies.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Tenda·\n El quiosc de l\'Urahara ha fet remodelatge!\n Ara es possible fer tirades de 5 en 5, a més\n de tenir nous Banners(Shinigamis, Quincies, Hollows).\n Ja pots repondre les teves monedes amb diners reals!\n Mecànica nova afegida, si et toquen molts personatges repetits obtindràs fragments que et serviràn per poder comprar un personatge diàriament que no hagis obtingut.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Perfil·\n Duu la personalització a un altre nivell!\n S\'ha afegit un nou seguiment per nivells amb sistema d\'experiència.\n Podràs equipar titols de personatges al teu perfil',
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
