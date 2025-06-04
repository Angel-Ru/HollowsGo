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
                  NoticiaText(
                    text:
                        '📢 ·Versió 1.0 de "HollowsGO:Remastered·"\nja disponible!\nActualització ambientada en l\'arc més recent de l\'Anime\nEl Thousand Year Blood War.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'lib/images/prehomescreen_images/HollowsGo_Remastered_LOGO.png',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '💡 ·Nous Personatges·\nAfegits un total de 33 personatges nous i un total de 74 skins noves, afegint-hi la raça dels Quincies i fent jugables als Hollows i a Quincies.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Tenda·\nEl quiosc de l\'Urahara ha fet remodelatge!\nAra es possible fer tirades de 5 en 5, a més de tenir nous Banners(Shinigamis, Quincies, Hollows).\nJa pots repondre les teves monedes amb diners reals!\nMecànica nova afegida, si et toquen molts personatges repetits obtindràs fragments que et serviràn per poder comprar un personatge diàriament que no hagis obtingut.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Combat·\nEls combats ara són més frenètics que mai!\nAfegides les noves Habilitats Llegendàries, només alguns personatges tenen el privilegi de tenir-les, les podràs emprar totes?\nCanvi d\'enemics entre dia i nit.\n(00:00 - 17:00 Quincies) (17:00 - 00:00 Hollows) \nHi ha conseqüències a l\'hora de fer un combat, en acabar-se el mateix es queda guardada la vida del teu personatge. Planteja bé les teves estratègies. \nEls personatges es poden curar amb els nous vials que es regeneren cada 5 hores del darrer ús.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Missions·\nAnima\'t a aconseguir noves recompenses!\nNova rotació de missions diàries amb recompenses, a més ara els personatges tenen missions asignades cada un per aconseguir les seves armes i el titol de personatge del mateix.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Biblioteca·\nA la biblioteca ara podràs assignar-te un personatge preferit i una skin preferida, també és on podràs curar al teus personatges i veure la vida dels mateixos.\nMantenint polsat a sobre la skin li podràs equipar les armes que sumaràn "Mal" a les seves estadístiques.\nA més, ara hi ha noves entrades d\'informació per cada personatge amb història dels mateixos.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Perfil·\nDuu la personalització a un altre nivell!\nS\'ha afegit un nou seguiment per nivells amb sistema d\'experiència.\nPodràs equipar titols de personatges al teu perfil, i veure les teves estadístiques al teu perfil.',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Amistats·\nComparteix el teu compte amb els teus amics!\nNou sistema d\'amistats inclòs al joc, ara pots afegir als teus amics a "HollowsGo" poguent compartir els vostres perfils.\nEt picaràs amb les teves amistats per a veure qui aconsegueix tots els personatges primer?',
                  ),
                  SizedBox(height: 12),
                  Image.asset(
                    'assets/images/consell.jpg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 12),
                  NoticiaText(
                    text:
                        '🗞️ ·Configuració·\nNova pantalla de configuració on, podràs modificar el volum del teu dispositiu, l\'abrillantament, a més de poder veure el nou tutorial, fet per nous integrats.\n També podràs eliminar el teu compte d\'usuari si ho necessites, a més de l\'opció de tancar sessió',
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

class NoticiaText extends StatelessWidget {
  final String text;

  const NoticiaText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: lines.map((line) {
        final trimmed = line.trimRight();

        if (trimmed.isEmpty) {
          return SizedBox(height: 12); // espai entre línies buides
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            trimmed,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: trimmed.startsWith('📢') ||
                      trimmed.startsWith('💡') ||
                      trimmed.startsWith('🗞️')
                  ? Colors.amberAccent
                  : Colors.white70,
              fontSize: trimmed.startsWith('📢') ||
                      trimmed.startsWith('💡') ||
                      trimmed.startsWith('🗞️')
                  ? 20
                  : 14,
              fontWeight: trimmed.startsWith('📢') ||
                      trimmed.startsWith('💡') ||
                      trimmed.startsWith('🗞️')
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }
}
