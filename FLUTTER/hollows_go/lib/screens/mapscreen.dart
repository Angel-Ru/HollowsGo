import 'package:hollows_go/imports.dart';

class Mapscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PreHomeScreen()),
      );
    }

    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
