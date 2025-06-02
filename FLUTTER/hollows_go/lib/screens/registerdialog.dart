import 'package:http/http.dart' as http;
import '../imports.dart';
import '../service/audioservice.dart';
import '../widgets/animationdialeg.dart';
import '../widgets/customtext_widget.dart';

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
void initState() {
  super.initState();
  AudioService.instance.pause(); // 👈 Pausar música en obrir el registre
}


  @override
void dispose() {
  _usernameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();

  // Només reprendre si seguim a la PreHomeScreen
  AudioService.instance.resume(); // 👈 Reprendre música si tanca el registre

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
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16,
    );
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
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

  setState(() => _isLoading = true);

  final url = Uri.parse('https://${Config.ip}/usuaris/');
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
      final token = responseData['token'];

      await _clearPreferences();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', user['id']);
      await prefs.setString('userEmail', user['email']);
      await prefs.setString('userName', user['nom']);
      await prefs.setInt('userPunts', user['punts_emmagatzemats']);
      await prefs.setInt('userTipo', user['tipo']);
      await prefs.setString('token', token);

      _showToast("T'has registrat correctament");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      final errorMsg = responseData['message'] ?? "Error desconegut";
      _showToast("Error: $errorMsg");
    }
  } catch (e) {
    _showToast("Error de connexió: $e");
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AnimatedDialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/originals/6f/f0/56/6ff05693972aeb7556d8a76907ddf0c7.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Crea el teu compte',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nom
                  CustomTextField(
                    controller: _usernameController,
                    label: 'Nom',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  // Contrasenya
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Contrasenya',
                    icon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: Color.fromARGB(233, 255, 255, 255),
                      ),
                      onPressed: () {
                        setState(() => _isPasswordVisible = !_isPasswordVisible);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel·la',
                          style: TextStyle(color: Color.fromARGB(233, 255, 255, 255)),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent.shade200,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                            : const Text('Registra\'t'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
