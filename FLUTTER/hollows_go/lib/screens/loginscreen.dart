import 'package:http/http.dart' as http;
import '../imports.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showSnackBar("Tots els camps són obligatoris");
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('https://${Config.ip}/usuaris/login');
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
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', data['user']['id']);
        await prefs.setString('userEmail', data['user']['email']);
        await prefs.setString('userName', data['user']['nom']);
        await prefs.setInt('userPunts', data['user']['punts_emmagatzemats']);
        await prefs.setInt('userTipo', data['user']['tipo']);
        await prefs.setString('token', data['token']);

        _showSnackBar("Inici de sessió correcte");
        Navigator.of(context).pop(true);
      } else {
        _showSnackBar(data['message'] ?? "Error desconegut");
      }
    } catch (e) {
      _showSnackBar("Error de connexió: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/originals/f3/00/7c/f3007cfb61fa557ae8a56685dc9d4a4c.jpg'), // Cambia por la imagen que prefieras
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.75), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Inicia sessió',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade300,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                    _usernameController, 'Email', Icons.person_outline),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Cancel·la',
                        style: TextStyle(
                            color: Color.fromARGB(233, 255, 255, 255)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent.shade200,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Inicia sessió'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => RegisterDialog(),
                    );
                  },
                  child: const Text(
                    "Registra't",
                    style: TextStyle(color: Color.fromARGB(233, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(233, 255, 255, 255)),
        prefixIcon: Icon(icon, color: Color.fromARGB(233, 255, 255, 255)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Contrasenya',
        labelStyle: const TextStyle(color: Color.fromARGB(233, 255, 255, 255)),
        prefixIcon: const Icon(Icons.lock_outline,
            color: Color.fromARGB(233, 255, 255, 255)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Color.fromARGB(233, 255, 255, 255),
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
