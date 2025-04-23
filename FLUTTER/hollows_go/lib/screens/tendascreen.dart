import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollows_go/providers/dialeg_provider.dart';
import 'package:hollows_go/providers/gacha_provider.dart';
import 'package:hollows_go/widgets/gachavideodialog.dart';
import 'package:hollows_go/widgets/skinrewarddialog.dart';
import 'package:provider/provider.dart';

class TendaScreen extends StatefulWidget {
  @override
  _TendaScreenState createState() => _TendaScreenState();
}

class _TendaScreenState extends State<TendaScreen> {
  final List<String> _backgroundImages = [
    'lib/images/Yoroichi.jpeg',
    'lib/images/Byakuya.jpeg',
  ];

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _startBackgroundRotation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
        dialogueProvider.loadDialogueFromJson('urahara');
      
    });
  }

  void _startBackgroundRotation() {
    Future.delayed(Duration(seconds: 20), () {
      if (!mounted) return;
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % _backgroundImages.length;
      });
      _startBackgroundRotation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gachaProvider = Provider.of<GachaProvider>(context);
    final dialogueProvider = Provider.of<DialogueProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white.withOpacity(0.5),
              elevation: 0,
              title: null,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Duration(seconds: 2),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: SizedBox.expand(
                key: ValueKey(_backgroundImages[_currentImageIndex]),
                child: Image.asset(
                  _backgroundImages[_currentImageIndex],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: MediaQuery.of(context).size.width * 0.15,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey[700]!.withOpacity(0.8),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'lib/images/banner_gacha/banner.png',
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.38,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final success = await gachaProvider.gachaPull(context);

                    if (success && gachaProvider.latestSkin != null) {
                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => GachaVideoPopup(
                          onVideoEnd: () {
                            showDialog(
                              context: context,
                              builder: (_) => SkinRewardDialog(
                                skin: gachaProvider.latestSkin!,
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Tirar Gacha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..color = Color(0xFFFF6A13)
                        ..style = PaintingStyle.stroke,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8B400),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: dialogueProvider.nextDialogue,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage(dialogueProvider.currentImage),
                        backgroundColor: Color.fromARGB(255, 151, 250, 173),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap:  dialogueProvider.nextDialogue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(243, 194, 194, 194),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Kisuke Urahara',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(212, 238, 238, 238),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                dialogueProvider.currentDialogue,
                                style: TextStyle(
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
                SizedBox(height: 16),
                if (gachaProvider.isLoading)
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
