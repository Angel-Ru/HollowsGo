import 'package:flutter/material.dart';
import 'package:hollows_go/models/avatar.dart';
import 'package:hollows_go/providers/perfil_provider.dart';

import '../imports.dart';

class ImageSelectionPage extends StatefulWidget {
  final Function(String) onImageSelected;

  ImageSelectionPage({super.key, required this.onImageSelected});

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  late Future<List<Avatar>> _avatarFuture;
  late Future<String> _avatarActualUrlFuture;
  final PerfilProvider _perfilProvider = PerfilProvider();

  @override
  void initState() {
    super.initState();
    _avatarFuture = _perfilProvider.getAvatars();

    SharedPreferences.getInstance().then((prefs) {
      final userId = prefs.getInt('userId');
      if (userId != null) {
        setState(() {
          _avatarActualUrlFuture = _perfilProvider.obtenirAvatar(userId);
        });
      }
    });
  }

  Future<void> _selectAvatar(Avatar avatar) async {
    await _perfilProvider.actualitzarAvatar(avatar.id);
    widget.onImageSelected(avatar.url);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Selecciona una imatge'),
        ),
        body: Column(
          children: [
            FutureBuilder<String>(
              future: _avatarActualUrlFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No s\'ha pogut carregar l\'avatar actual.'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text('Avatar actual:'),
                      SizedBox(height: 8),
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(snapshot.data!),
                      ),
                    ],
                  ),
                );
              },
            ),
            Expanded(
              child: FutureBuilder<List<Avatar>>(
                future: _avatarFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error carregant els avatars'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hi ha avatars disponibles.'));
                  }

                  final avatars = snapshot.data!;

                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: avatars.length,
                    itemBuilder: (context, index) {
                      final avatar = avatars[index];
                      return GestureDetector(
                        onTap: () => _selectAvatar(avatar),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            avatar.url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
