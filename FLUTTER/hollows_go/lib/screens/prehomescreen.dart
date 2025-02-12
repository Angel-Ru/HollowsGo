import 'package:hollows_go/imports.dart';

class PreHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2), // Color lila claro de fondo
      body: GestureDetector(
        onTap: () {
          Provider.of<LoginProvider>(context, listen: false).checkLogin(
              context); // Mostrar el diálogo de login al tocar la pantalla
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset("lib/images/skull_border.png", fit: BoxFit.cover),
                Spacer(),
                Image.asset("lib/images/kon.png", width: 200),
                Spacer(),
                Text("TAP ANYWHERE TO ENTER",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Image.asset("lib/images/skull_border.png", fit: BoxFit.cover),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Image.asset("lib/images/nom_aplicacio.png", width: 250),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
