import 'package:http/http.dart' as http;
import '../imports.dart';

/*
Aquesta és la classe RegisterDialog. En aquesta classe es crea el diàleg de registre.
En aquest diàleg ens connectam amb el servidor per a poder-nos crear un compte per a poder-nos connectar a l'aplicació.
Un cop ens hem registrat, ens redirigeix a la pantalla principal de l'aplicació, la qual és la HomeScreen.
S'ha de canviar l'IP del servidor per a que funcioni correctament.
*/

class RegisterDialog extends StatefulWidget {
  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool _isEmailValid(String email) {
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.length >= 6;
  }

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showToast("Tots els camps són obligatoris");
      return;
    }

    if (!_isEmailValid(email)) {
      _showToast("El correu electrònic no és vàlid");
      return;
    }

    if (!_isPasswordValid(password)) {
      _showToast("La contrasenya ha de tenir almenys 6 caràcters");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://192.168.1.28:3000/usuaris/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "nom": username,
      "email": email,
      "contrassenya": password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final user = responseData['user'];
        final token = responseData['token']; // Obtenir el token JWT

        await _clearPreferences();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', user['email']);
        await prefs.setString('userName', user['nom']);
        await prefs.setInt('userPunts', user['punts_emmagatzemats']);
        await prefs.setInt('userTipo', user['tipo']);

        // Guardar el token JWT
        await prefs.setString('token', token); // Aquí es guarda el token

        _showToast("T'has registrat correctament");

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        final errorMsg = responseData['message'] ?? "Error desconegut";
        _showToast("Error: $errorMsg");
      }
    } catch (e) {
      _showToast("Error de connexió: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registra\'t'),
      content: Container(
        width: 300,
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contrasenya',
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel·la'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _register,
          child: _isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Registra\'t'),
        ),
      ],
    );
  }
}
