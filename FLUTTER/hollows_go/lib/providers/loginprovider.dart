import 'package:hollows_go/imports.dart';

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
