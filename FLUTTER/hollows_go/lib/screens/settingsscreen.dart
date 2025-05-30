import 'dart:ui';
import 'package:http/http.dart' as http;
import '../imports.dart'; // Inclou aquí el teu import general

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _currentBrightness = 0.5;
  double _volume = 0.5;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initBrightness();
    _initVolume();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('Shinji');
    });
  }

  Future<void> _initBrightness() async {
    try {
      _currentBrightness = await ScreenBrightness().current ?? 0.5;
      setState(() {});
    } catch (e) {
      print("Error al obtenir lluminositat: $e");
    }
  }

  Future<void> _initVolume() async {
    try {
      _volume = await FlutterVolumeController.getVolume() ?? 0.5;
      _isMuted = await FlutterVolumeController.getMute() ?? false;
      setState(() {});
    } catch (e) {
      print("Error al obtenir volum: $e");
    }
  }

  Future<void> _setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
      setState(() {
        _currentBrightness = value;
      });
    } catch (e) {
      print("Error al canviar la lluminositat: $e");
    }
  }

  Future<void> _setVolume(double value) async {
    try {
      await FlutterVolumeController.setVolume(value);
      setState(() {
        _volume = value;
        _isMuted = value == 0;
      });
    } catch (e) {
      print("Error al canviar el volum: $e");
    }
  }

  Future<void> _toggleMute() async {
    try {
      bool newMuteState = !_isMuted;
      await FlutterVolumeController.setMute(newMuteState);
      setState(() {
        _isMuted = newMuteState;
        if (newMuteState) {
          _volume = 0;
        } else {
          _volume = _volume == 0 ? 0.5 : _volume;
        }
      });
    } catch (e) {
      print("Error al mutar: $e");
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PreHomeScreen()),
    );
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final token = prefs.getString('token');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
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
                border: Border.all(
                  color: Colors.orangeAccent,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Eliminar compte',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Estàs segur que vols eliminar el teu compte?\nPerdràs totes les dades.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sí'),
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

    if (confirm == true && userId != null && token != null) {
      final response = await http.delete(
        Uri.parse('https://${Config.ip}/usuaris/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PreHomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el compte')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Configuració'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage('lib/images/settings_screen/fons_settings.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 80, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lluminositat de la pantalla',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.brightness_low, color: Colors.white),
                            Expanded(
                              child: Slider(
                                value: _currentBrightness,
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                onChanged: _setBrightness,
                                activeColor: Colors.yellow,
                                inactiveColor: Colors.grey[300],
                              ),
                            ),
                            Icon(Icons.brightness_high, color: Colors.white),
                          ],
                        ),
                        Center(
                          child: Text(
                            '${(_currentBrightness * 100).round()}%',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Text(
                          'Volum del dispositiu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.volume_down, color: Colors.white),
                            Expanded(
                              child: Slider(
                                value: _volume,
                                min: 0.0,
                                max: 1.0,
                                divisions: 100,
                                onChanged: _setVolume,
                                activeColor: Colors.yellow,
                                inactiveColor: Colors.grey[300],
                              ),
                            ),
                            Icon(Icons.volume_up, color: Colors.white),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up),
                            label: Text(_isMuted ? 'Desmutar' : 'Mutar'),
                            onPressed: _toggleMute,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.school),
                            label: Text('Tutorial'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blueAccent,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TutorialScreen()),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // ✅ Botó d'eliminar compte
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.delete_forever),
                            label: Text('Eliminar Compte'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.deepOrangeAccent,
                            ),
                            onPressed: _deleteAccount,
                          ),
                        ),
                        SizedBox(height: 20),

                        // 🚪 Botó Logout
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.logout),
                            label: Text('Tancar Sessió'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.red,
                            ),
                            onPressed: _logout,
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: DialogueWidget(
                  characterName: 'Shinji Hirako',
                  nameColor: const Color.fromARGB(255, 231, 213, 50),
                  bubbleColor: Color.fromARGB(212, 238, 238, 238),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
