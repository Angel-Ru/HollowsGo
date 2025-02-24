import 'package:http/http.dart' as http;
import '../imports.dart';

/*
En la classe es gestiona i crea el diàleg de login.
En aquest diàleg es connecta amb el servidor per a comprovar les dades d'inici de sessió.
Un cop les dades són correctes, es redirigeix a la pantalla principal de l'aplicació, la qual és la HomeScreen.
*/

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  Future<void> _login() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    _showSnackBar("Tots els camps són obligatoris");
    return;
  }

  setState(() {
    _isLoading = true;
  });

  final url = Uri.parse('http://192.168.2.197:3000/usuaris/login');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    'email': username,
    'contrassenya': password,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      // Guardar l'estat de login i les dades de l'usuari
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', data['user']['id']);
      await prefs.setString('userEmail', data['user']['email']);
      await prefs.setString('userName', data['user']['nom']);
      await prefs.setInt('userPunts', data['user']['punts_emmagatzemats']);
      await prefs.setInt('userTipo', data['user']['tipo']);

      // Imprimir el token per consola
      print("Token rebut: ${data['token']}");

      // Guardar el token
      await prefs.setString('token', data['token']);

      _showSnackBar("Inici de sessió correcte");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _showSnackBar(data['message'] ?? "Error desconegut");
    }
  } catch (e) {
    _showSnackBar("Error de connexió: $e");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Inicia sessió'),
      content: Container(
        width: 300,
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contrassenya',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel·la'),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Inicia sessió'),
            ),
          ],
        ),
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => RegisterDialog(),
              );
            },
            child: Text("Registra't"),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
