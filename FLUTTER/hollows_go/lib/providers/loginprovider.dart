import '../imports.dart';

/*
El LoginProvider és el provider que s'encarrega de gestionar el login de l'usuari.
Aquest provider comprova si l'usuari ja ha iniciat sessió i, en cas contrari, mostra la pantalla de login.
*/

class LoginProvider with ChangeNotifier {
  Future<void> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('isLoggedIn') ?? false)) {
      final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoginScreen();
        },
      );

      if (result == true) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
