import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hollows_go/providers/dialeg_provider.dart';
import 'package:hollows_go/providers/gacha_provider.dart';
import 'package:hollows_go/widgets/bannergachawidget.dart';
import 'package:hollows_go/widgets/dialogue_widget.dart';
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
                GachaBannerWidget(),
                SizedBox(height: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 20),
                DialogueBox(
                  characterName: 'Kisuke Urahara',
                  nameColor: Colors.green,
                  bubbleColor: Color.fromARGB(212, 238, 238, 238),
                  backgroundColor: Color.fromARGB(255, 151, 250, 173),
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
