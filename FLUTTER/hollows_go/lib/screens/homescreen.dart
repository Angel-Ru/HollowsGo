import 'package:hollows_go/imports.dart';

class HomeScreen extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
