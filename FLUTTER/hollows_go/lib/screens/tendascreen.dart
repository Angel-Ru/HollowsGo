import 'package:hollows_go/imports.dart';

class TendaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Deshabilitar la flecha de retroceso
        title: null, // Quitar el título
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/urahara_character/urahara_1.png',
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              "Hola, sóc l'Urahara, i sigues benvingut a la tenda!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Aqui podràs fer les diverses tirades al gatxa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
