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
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildBackButton(),
                CurrentAvatarDisplay(avatarFuture: _avatarActualUrlFuture),
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

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}
