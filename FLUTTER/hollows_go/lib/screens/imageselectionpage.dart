import 'package:hollows_go/service/audioservice.dart';

import '../imports.dart';
import 'dart:ui'; // Per BackdropFilter

class ImageSelectionPage extends StatefulWidget {
  final Function(String) onImageSelected;

  const ImageSelectionPage({super.key, required this.onImageSelected});

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  late Future<List<Avatar>> _avatarFuture;
  Future<String>? _avatarActualUrlFuture;
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTopBar(), // ✅ Barra superior nova

                if (_avatarActualUrlFuture != null)
                  CurrentAvatarDisplay(avatarFuture: _avatarActualUrlFuture!),

                Expanded(
                  child: FutureBuilder<List<Avatar>>(
                    future: _avatarFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Image(
                            image: AssetImage('assets/loading/loading.gif'),
                            width: 60,
                            height: 60,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Error carregant els avatars',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hi ha avatars disponibles.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return AvatarGrid(
                        avatars: snapshot.data!,
                        onAvatarSelected: _selectAvatar,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Nova barra superior amb blur i estil translúcid
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    AudioService.instance.playScreenMusic('perfil');
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Edita Perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 48), // Per equilibrar amb l'IconButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
