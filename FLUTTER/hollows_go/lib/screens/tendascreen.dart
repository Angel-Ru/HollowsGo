import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _startBackgroundRotation();

    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogueProvider =
          Provider.of<DialogueProvider>(context, listen: false);
      dialogueProvider.loadDialogueFromJson('urahara');
    });
  }

  void _playBackgroundMusic() async {
    final List<String> musicUrls = [
      'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dq2skhigp8ml5kjysdl8',
      'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/n47sbuwwhjntfd5tplpl',
      'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/wqjoawsw8v7igikmuym4',
      'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/nzvkinzhqcoor7hdb72n',
      'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dtofpubrwmruyye4kajd',
    ];

    final randomUrl = (musicUrls..shuffle()).first;

    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(UrlSource(randomUrl));
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
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Diàleg modal per mostrar la Skin del Dia
  void _showSkinDelDiaDialog(BuildContext context, Map<String, dynamic>? skin) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Skin del Dia",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (skin != null && skin['imageUrl'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      skin['imageUrl'],
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    ),
                  )
                else
                  Container(
                    height: 180,
                    alignment: Alignment.center,
                    child: Text(
                      "No hi ha cap skin disponible avui.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                SizedBox(height: 16),
                if (skin != null && skin['description'] != null)
                  Text(
                    skin['description'],
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Tancar"),
                ),
              ],
            ),
          ),
        );
      },
    );
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
          // 🔹 Fons rotatiu
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

          // 🔹 Contingut deslliçable
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              children: [
                _buildGachaContent(gachaProvider),
                _buildMonedesPage(),
              ],
            ),
          ),

          // 🔹 Diàleg i loader a la part inferior
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
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGachaContent(GachaProvider gachaProvider) {
    return Column(
      children: [
        SizedBox(height: 150),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
          ),
          child: Column(
            children: [
              GachaBannerWidget(),
              SizedBox(height: 20),

              // Carta Skin del Dia
              Card(
                color: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Skin del Dia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: Icon(Icons.visibility),
                        label: Text("Veure Skin"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          _showSkinDelDiaDialog(context, gachaProvider.latestSkin);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMonedesPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 150, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compra de monedes',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(2, 2),
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          _monedaOption("100 monedes", "0,99 €"),
          _monedaOption("500 monedes", "4,49 €"),
          _monedaOption("1000 monedes", "7,99 €"),
          _monedaOption("1500 monedes", "14,99 €"),
        ],
      ),
    );
  }

  Widget _monedaOption(String title, String priceDisplay) {
    final priceValue =
        priceDisplay.replaceAll('€', '').replaceAll(',', '.').trim();

    final puntsComprats = int.tryParse(title.split(' ').first) ?? 0;

    return Card(
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(priceDisplay,
            style: TextStyle(color: Colors.green, fontSize: 16)),
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
      ),
    );
  }
}
