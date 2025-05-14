import 'package:hollows_go/providers/perfil_provider.dart';

import '../imports.dart'; // Assegura't que aquí tens el teu PerfilProvider i dependències

class ImageSelectionPage extends StatefulWidget {
  final Function(String) onImageSelected;

  ImageSelectionPage({super.key, required this.onImageSelected});

  @override
  _ImageSelectionPageState createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  final PerfilProvider _perfilProvider = PerfilProvider();
  late Future<List<String>> _avatarFuture;

  final List<String> _dialogues = [
    "Escollir perfil? Si vols, jo t’ajudo… amb una cervesa a la mà!",
    "Jo sempre escolliria un perfil amb més estil. Què me’n dius?",
    "Escollir perfil? Jo tinc una copa per cada opció. Tria la que més t’agradi.",
    "Molt bé, no cal pensar-hi tant… només escull el millor!",
  ];

  final List<String> _kyorakuImages = [
    'lib/images/kyoraku_character/kyoraku_1.png',
    'lib/images/kyoraku_character/kyoraku_2.png',
    'lib/images/kyoraku_character/kyoraku_3.png',
    'lib/images/kyoraku_character/kyoraku_4.png',
    'lib/images/kyoraku_character/kyoraku_5.png',
  ];

  int _dialogIndex = 0;
  late String _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = _kyorakuImages[0];
    _avatarFuture = _perfilProvider.getAvatars();
  }

  void _nextDialogue() {
    setState(() {
      _dialogIndex = (_dialogIndex + 1) % _dialogues.length;
      String newImage;
      do {
        newImage = _kyorakuImages[Random().nextInt(_kyorakuImages.length)];
      } while (newImage == _currentImage);
      _currentImage = newImage;
    });
  }

  Future<void> _selectAvatar(String avatarUrl) async {
    try {
      await _perfilProvider.actualitzarAvatar(avatarUrl);
      widget.onImageSelected(avatarUrl);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualitzar l\'avatar: $e')),
      );
    }
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
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _avatarFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error carregant avatars: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No hi ha avatars disponibles.'));
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
                      return GestureDetector(
                        onTap: () => _selectAvatar(avatars[index]),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            avatars[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _nextDialogue,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(_currentImage),
                      backgroundColor: const Color.fromARGB(255, 245, 181, 234),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _nextDialogue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(243, 194, 194, 194),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Shunsui Kyoraku',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 6, 7, 6),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 245, 181, 234),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              _dialogues[_dialogIndex],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
