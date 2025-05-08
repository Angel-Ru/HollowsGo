import 'package:flutter/material.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:screen_brightness/screen_brightness.dart';

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
  }

  // Inicializa el brillo
  Future<void> _initBrightness() async {
    try {
      _currentBrightness = await ScreenBrightness().current ?? 0.5;
      setState(() {});
    } catch (e) {
      print("Error al obtenir lluminositat: $e");
    }
  }

  // Inicializa el volumen y el estado de muteo
  Future<void> _initVolume() async {
    try {
      _volume = await FlutterVolumeController.getVolume() ?? 0.5;
      _isMuted = await FlutterVolumeController.getMute() ?? false;
      setState(() {});
    } catch (e) {
      print("Error al obtenir volum: $e");
    }
  }

  // Ajusta el brillo
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

  // Ajusta el volumen
  Future<void> _setVolume(double value) async {
    try {
      await FlutterVolumeController.setVolume(value);
      setState(() {
        _volume = value;
        _isMuted = value == 0; // Si el volumen es 0, está muteado
      });
    } catch (e) {
      print("Error al canviar el volum: $e");
    }
  }

  // Cambia el estado de muteo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuració'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de brillo
            Text(
              'Lluminositat de la pantalla',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.brightness_low, color: Colors.grey),
                Expanded(
                  child: Slider(
                    value: _currentBrightness,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    onChanged: _setBrightness,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey[300],
                  ),
                ),
                Icon(Icons.brightness_high, color: Colors.grey),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                '${(_currentBrightness * 100).round()}%',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            SizedBox(height: 40),

            // Sección de volumen
            Text(
              'Volum del dispositiu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 100,
                    onChanged: _setVolume,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey[300],
                  ),
                ),
                Icon(Icons.volume_up),
              ],
            ),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                label: Text(_isMuted ? 'Desmutar' : 'Mutar'),
                onPressed: _toggleMute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
