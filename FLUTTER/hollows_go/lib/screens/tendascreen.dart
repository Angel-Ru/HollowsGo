import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hollows_go/service/audioservice.dart';
import 'package:hollows_go/widgets/custom_loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:hollows_go/widgets/tenda/paypal_payment_widget.dart';

import '../imports.dart';

class TendaScreen extends StatefulWidget {
  @override
  _TendaScreenState createState() => _TendaScreenState();
}

class _TendaScreenState extends State<TendaScreen> {
  final PageController _pageController = PageController();
  final List<String> _backgroundImages = [
    'lib/images/fondo_tendascreen/Aizen.jpg',
    'lib/images/fondo_tendascreen/Aporro.jpg',
    'lib/images/fondo_tendascreen/Byakuya.jpg',
    'lib/images/fondo_tendascreen/Gigachad.jpg',
    'lib/images/fondo_tendascreen/Gin.jpg',
    'lib/images/fondo_tendascreen/Grimmjow.jpg',
    'lib/images/fondo_tendascreen/Halibel.jpg',
    'lib/images/fondo_tendascreen/Hisagi.jpg',
    'lib/images/fondo_tendascreen/Ikkaku.jpg',
    'lib/images/fondo_tendascreen/Ishida.jpg',
    'lib/images/fondo_tendascreen/Kaien.jpg',
    'lib/images/fondo_tendascreen/Kira.jpg',
    'lib/images/fondo_tendascreen/Komamura.jpg',
    'lib/images/fondo_tendascreen/Kulosaki.jpg',
    'lib/images/fondo_tendascreen/Kyoraku.jpg',
    'lib/images/fondo_tendascreen/Matsumoto.jpg',
    'lib/images/fondo_tendascreen/Mayurin.jpg',
    'lib/images/fondo_tendascreen/Nelliel.jpg',
    'lib/images/fondo_tendascreen/Nnoitra.jpg',
    'lib/images/fondo_tendascreen/Renji.jpg',
    'lib/images/fondo_tendascreen/Rukia.jpg',
    'lib/images/fondo_tendascreen/Shinji.jpg',
    'lib/images/fondo_tendascreen/SoiFon.jpg',
    'lib/images/fondo_tendascreen/Stark.jpg',
    'lib/images/fondo_tendascreen/Tosen.jpg',
    'lib/images/fondo_tendascreen/Toshiro.jpg',
    'lib/images/fondo_tendascreen/Ulquiorra.jpg',
    'lib/images/fondo_tendascreen/Urahara.jpg',
    'lib/images/fondo_tendascreen/Yamamoto.jpg',
    'lib/images/fondo_tendascreen/Yoruichi.jpg',
  ];
  int _currentImageIndex = 0;
  bool _mostrarSkin = false;

  @override
  void initState() {
    super.initState();

    _startBackgroundRotation();

    AudioService.instance.playScreenMusic('tenda');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('urahara');

      final gachaProvider = Provider.of<GachaProvider>(context, listen: false);

      // Aquí fem el fetch un cop
      await gachaProvider.fetchFragmentsSkinsUsuari(context);

      bool success = await gachaProvider.getSkinDelDia(context);

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No s\'ha pogut carregar la Skin del Dia.')),
        );
      }
      setState(() {});
    });
  }

  void _startBackgroundRotation() {
    Future.delayed(Duration(seconds: 8), () {
      if (!mounted) return;
      setState(() {
        _currentImageIndex =
            (_currentImageIndex + 1) % _backgroundImages.length;
      });
      _startBackgroundRotation();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: [
                _buildGachaContent(gachaProvider),
                _buildMonedesPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 10),
                DialogueWidget(
                  characterName: 'Kisuke Urahara',
                  nameColor: Colors.green,
                  bubbleColor: Color.fromARGB(212, 238, 238, 238),
                ),
                if (gachaProvider.isLoading)
                  Center(child: CustomLoadingIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaContent(GachaProvider gachaProvider) {
    final skin = gachaProvider.latestSkin;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: 150),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.15,
          ),
          child: Column(
            children: [
              GachaBannerWidget(),
              SizedBox(height: 5),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: screenWidth * 0.65 > 600 ? 600 : screenWidth * 0.65,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              color: Colors.black.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: Color(0xFF1B5E20),
                  width: 1.5,
                ),
              ),
              elevation: 8,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Fragments: ${gachaProvider.latestFragmentsSkins?['fragments_skins']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        _mostrarSkin
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarSkin = !_mostrarSkin;
                        });
                      },
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: SizedBox.shrink(),
                    secondChild: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          if (skin != null && skin['imatge'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                skin['imatge'],
                                height: 115,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          else
                            Container(
                              height: 140,
                              alignment: Alignment.center,
                              child: Text(
                                "El proxim pic que tornis haurà una nova skin.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          SizedBox(height: 4),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (skin == null) return;
                              bool success =
                                  await gachaProvider.comprarSkinDelDia(
                                context,
                                skin['id'],
                                skin['personatge'],
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text("Has comprat la Skin del Dia!"),
                                  ),
                                );
                              }
                            },
                            child: Text('x100 Frags'),
                          ),
                        ],
                      ),
                    ),
                    crossFadeState: _mostrarSkin
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMonedesPage() {
  return Padding(
    padding: const EdgeInsets.only(top: 150, left: 24, right: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.green.withOpacity(0.7),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.15),
                offset: Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.local_mall, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Stack(
                children: [
                  // Contorn verd per donar un toc "misteriós"
                  Text(
                    'Compra de monedes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = Color(0xFF1B5E20),
                    ),
                  ),
                  // Text blanc per dins
                  Text(
                    'Compra de monedes',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.green.withOpacity(0.4),
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        _monedaOption("100 monedes", "0,99 €"),
        _monedaOption("500 monedes", "4,49 €"),
        _monedaOption("1000 monedes", "7,99 €"),
        _monedaOption("1500 monedes", "12,99 €"),
      ],
    ),
  );
}

Widget _monedaOption(String title, String priceDisplay) {
  final priceValue =
      priceDisplay.replaceAll('€', '').replaceAll(',', '.').trim();

  final puntsComprats = int.tryParse(title.split(' ').first) ?? 0;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaypalPaymentScreen(
            totalAmount: priceValue,
            itemName: title,
            puntsComprats: puntsComprats,
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.4),
            Colors.green.withOpacity(0.5), // només un petit toc de verd
          ],
          stops: [0.0, 0.9, 1.0], // 90% negre, 10% verd
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.6),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
          Text(
            priceDisplay,
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.green.withOpacity(0.5),
                  offset: Offset(0, 1),
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
