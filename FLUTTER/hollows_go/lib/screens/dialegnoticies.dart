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
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Combat·\n Els combats ara són més frenètics que mai!\n Afegides les noves Habilitats Llegendàries, només alguns personatges tenen el privilegi de tenir-les, les podràs emprar totes?\n Canvi d\'enemics entre dia i nit, \n Hi ha conseqüències a l\'hora de fer un combat, en acabar-se el mateix es queda guardada la vida del teu personatge. Planteja bé les teves estratègies. \n Els personatges es poden curar amb els nous vials que es regeneren cada 5 hores del darrer ús.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    '🗞️ ·Missions·\n Anima\'t a aconseguir noves recompenses!\n Nova rotació de misions diàries amb recompenses, a més ara els personatges tenen misions asignades cada un per aconseguir les seves armes i el titol de personatge del mateix.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Biblioteca·\n  A la biblioteca ara podràs assignar-te un personatge preferit i una skin preferida, també és on podràs curar al teus personatges i veure la vida dels mateixos.\n Mantenint polsat a sobre la skin li podràs equipar les armes que sumaràn "Mal" a les seves estadístiques.\n A més, ara hi ha noves entrades d\'informació per cada personatge amb història dels mateixos.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Perfil·\n Duu la personalització a un altre nivell!\n S\'ha afegit un nou seguiment per nivells amb sistema d\'experiència.\n Podràs equipar titols de personatges al teu perfil, i veure les teves estadístiques al teu perfil.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Amistats·\n Comparteix el teu compte amb els teus amics!\n Nou sistema d\'amistats inclòs al joc, ara pots afegir als teus amics a "HollowsGo" poguent compartir els vostres perfils.\n Et picaràs amb les teves amistats per a veure qui aconsegueix tots els personatges primer?',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  Text(
                    '🗞️ ·Configuració·\n Nova pantalla de configuració on, podràs modificar el volum del teu dispositiu, l\'abrillantament, a més de poder veure el nou tutorial, fet per nous integrats ls teus amics a "HollowsGo" poguent compartir els vostres perfils.\n Et picaràs amb les teves amistats per a veure qui aconsegueix tots els personatges primer?',
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
