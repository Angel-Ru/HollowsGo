import 'package:animated_text_kit/animated_text_kit.dart';
import '../imports.dart';

class SkinRewardDialog extends StatelessWidget {
  final Map<String, dynamic>? skin;
  final bool isDuplicate;

  const SkinRewardDialog(
      {required this.skin, this.isDuplicate = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Center(
        child: Text(
          isDuplicate ? '🔁 Skin Repetida! 🔁' : '🎉 Nova Skin Obtinguda! 🎉',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Si no es repetida, mostram la skin que ha aconseguit l'usuari.
          if (!isDuplicate) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                skin?['imatge'] ?? '',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Has desbloquejat la skin:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            Center(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: ClipRect(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(
                        skin?['nom'] ?? '',
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    repeatForever: true,
                    pause: Duration(milliseconds: 100),
                  ),
                ),
              ),
            ),
          ],
          // Si es repetida, mostram un dialeg per advertir a l'usuari
          if (isDuplicate) ...[
            Image.asset(
              'lib/images/skinrepetida.gif',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              'Ja tens aquesta skin.\n Se ha retornat el cost del gacha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ]
        ],
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Acceptar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
