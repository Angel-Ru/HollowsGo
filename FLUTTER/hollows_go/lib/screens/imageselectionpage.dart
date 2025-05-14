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
  final PerfilProvider _perfilProvider = PerfilProvider();

  @override
  void initState() {
    super.initState();
    _avatarFuture = _perfilProvider.getAvatars(); // Carregar avatars al principi
  }

  // Mètode per actualitzar l'avatar seleccionat
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
        body: FutureBuilder<List<Avatar>>(
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

            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
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
                        onTap: () => _selectAvatar(avatar), // Selecciona avatar
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
