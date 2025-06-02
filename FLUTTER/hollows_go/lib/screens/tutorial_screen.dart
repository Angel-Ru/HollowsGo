import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hollows_go/providers/ui_provider.dart';
import 'package:hollows_go/screens/homescreen.dart';
import 'package:provider/provider.dart';
import '../providers/dialeg_provider.dart';
import '../widgets/dialogue_widget.dart';

class TutorialScreen extends StatefulWidget {
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  late PageController _pageController;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DialogueProvider>(context, listen: false)
          .loadTutorialDialogue('tutorial');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    if (_navigating) return;
    _navigating = true;

    // Carregar el diàleg d'Ichigo abans de navegar
    await Provider.of<DialogueProvider>(context, listen: false)
        .loadDialogueFromJson("ichigo");

    // Establir el menú a 'home'
    Provider.of<UIProvider>(context, listen: false).selectedMenuOpt = 0;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<bool> _onWillPop() async {
    final sortir = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/jesi4rdib6xl4m92hxu2',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black87,
                    BlendMode.darken,
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.amber,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      'https://res.cloudinary.com/dkcgsfcky/image/upload/f_auto,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_IMAGES/jesi4rdib6xl4m92hxu2',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Abandonar el tutorial?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estàs segur que vols abandonar el tutorial?\n'
                    'Si tens dubtes, el podràs repetir sempre que vulguis\n'
                    'a l\'icona de configuració ubicada a la secció del perfil.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Tanca el diàleg primer
                          _navigateToHome(); // I després torna a la home
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sí'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return sortir ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DialogueProvider>(context);
    final totalSteps = provider.dialogues.length;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: totalSteps == 0
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'lib/images/amistatsscreen/amistats_fondo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: totalSteps,
                            physics: provider.isLastStep
                                ? const NeverScrollableScrollPhysics()
                                : null,
                            onPageChanged: provider.setCurrentIndex,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _pageController,
                                builder: (context, child) {
                                  double value = 1.0;
                                  if (_pageController.position.haveDimensions) {
                                    value = (_pageController.page ?? 0) - index;
                                    value = (1 - (value.abs() * 0.3))
                                        .clamp(0.0, 1.0);
                                  }
                                  return Center(
                                    child: Transform.scale(
                                      scale: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Image.asset(
                                            'lib/images/tutorial_screen/Pas_$index.png',
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Text(
                                                  'No s\'ha trobat la imatge',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List<Widget>.generate(totalSteps, (index) {
                            bool isActive = index == provider.currentIndex;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 12 : 8,
                              height: isActive ? 12 : 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        if (provider.isLastStep)
                          ElevatedButton(
                            onPressed: _navigateToHome,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade700,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Finalitzar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        DialogueWidget(
                          characterName: 'KON',
                          nameColor: const Color.fromARGB(255, 233, 179, 3),
                          bubbleColor:
                              Colors.blueGrey.shade700.withOpacity(0.85),
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
