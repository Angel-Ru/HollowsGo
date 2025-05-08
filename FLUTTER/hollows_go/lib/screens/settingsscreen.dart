import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _currentBrightness = 0.5;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initBrightness();
  }

  Future<void> _initBrightness() async {
    try {
      // Obtener el brillo actual
      _currentBrightness = await ScreenBrightness().current ?? 0.5;
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print("Error al obtener el brillo: $e");
      setState(() {
        _currentBrightness = 0.5;
        _initialized = true;
      });
    }
  }

  Future<void> _setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
      setState(() {
        _currentBrightness = value;
      });
    } catch (e) {
      print("Error al cambiar lluminositat: $e");
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
      body: _initialized
          ? Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}