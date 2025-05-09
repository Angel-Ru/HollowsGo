import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/user_provider.dart';
import '../providers/perfil_provider.dart';
import 'imageselectionpage.dart';
import 'settingsscreen.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String _imagePath =
      'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745254001/CONFIGURATIONSCREEN/PROFILE_IMAGES/xj2epvx8tylh5qea2yic.jpg';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();

    
    // Carregar dades de perfil
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      print('User ID: $userId');
      final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
      perfilProvider.fetchPerfilData(userId!);
    });
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');
    setState(() {
      _imagePath =
          (imagePath != null && imagePath.isNotEmpty) ? imagePath : _imagePath;
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageSelectionPage(
          onImageSelected: (String imagePath) {
            setState(() {
              _imagePath = imagePath;
            });
            Navigator.of(context).pop(imagePath);
          },
        ),
      ),
    ).then((imagePath) async {
      if (imagePath != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', _imagePath);
      }
    });
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final perfilProvider = Provider.of<PerfilProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey[600],
                    size: 28,
                  ),
                ),
                iconSize: 36,
                onPressed: () => _navigateToSettings(context),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Avatar amb botó d'edició
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_imagePath),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: () => _pickImage(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              Text(
                userProvider.username,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TITOL USUARI',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Edició de títol d’usuari
                    },
                    child: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),

          // Estadístiques
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Partides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Personatges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jugades:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${perfilProvider.partidesJugades}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Guanyades:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${perfilProvider.partidesGuanyades}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'En possessió:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${perfilProvider.nombrePersonatges}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Skins:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${perfilProvider.nombreSkins}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
