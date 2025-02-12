import 'package:hollows_go/imports.dart';

class PreHomeScreen extends StatelessWidget {
  final List<String> imagePaths = [
    'lib/images/koncapitan.png',
    'lib/images/konepico.png',
    'lib/images/konlike.png',
    'lib/images/konbrillitos.png',
    'lib/images/konrap.png',
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final randomImage = random.nextInt(imagePaths.length);

    return Scaffold(
      backgroundColor: Color(0xFFEAE4F2), // Color lila claro de fondo
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                Container(
                  height: 200,
                  child: Image.asset(
                    imagePaths[randomImage],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 70),
                Text("CLICA A ON SIGUI PER COMENÇAR",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 150),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 39,
                        height: 39,
                        child: Image.asset(
                          "lib/images/skull_border.png",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 150),
                  Image.asset("lib/images/nom_aplicacio.png", width: 300),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
