import 'package:animated_text_kit/animated_text_kit.dart';
import '../imports.dart';

class SkinRewardDialog extends StatefulWidget {
  final Map<String, dynamic>? skin;
  final bool isDuplicate;

  const SkinRewardDialog({required this.skin, this.isDuplicate = false, Key? key}) : super(key: key);

  @override
  State<SkinRewardDialog> createState() => _SkinRewardDialogState();
}

class _SkinRewardDialogState extends State<SkinRewardDialog> {
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    final videoUrl = widget.skin?['video_especial'];
    if (videoUrl != null) {
      _videoController = VideoPlayerController.asset(videoUrl)
        ..initialize().then((_) {
          setState(() {});
          _videoController?.play();
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final skin = widget.skin;
    final isDuplicate = widget.isDuplicate;

    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.5),
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
                    Colors.black.withOpacity(0.2), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isDuplicate ? '🔁 Skin Repetida! 🔁' : '🎉 Nova Skin Obtinguda!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade300,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 🎬 Mostrar vídeo si hi ha habilitat llegendària
                if (!isDuplicate && _videoController != null && _videoController!.value.isInitialized)
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                else if (!isDuplicate)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      skin?['imatge'] ?? '',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 10),
                if (!isDuplicate) ...[
                  Text(
                    'Has desbloquejat la skin:',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: ClipRect(
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ScaleAnimatedText(
                              skin?['nom'] ?? '',
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          repeatForever: true,
                          pause: Duration(milliseconds: 100),
                        ),
                      ),
                    ),
                  ),
                ],
                if (isDuplicate) ...[
                  Image.asset(
                    'lib/images/skinrepetida.gif',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ja tens aquesta skin.\n Se ha retornat el cost del gacha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
                const SizedBox(height: 24),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade200,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Acceptar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
