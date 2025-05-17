import 'dart:ui';
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
            ),
          ),
          SizedBox(height: 30),
          _monedaOption("100 monedes", "0,99 €"),
          _monedaOption("550 monedes", "4,49 €"),
          _monedaOption("1200 monedes", "9,99 €"),
          _monedaOption("2500 monedes", "19,99 €"),
        ],
      ),
    );
  }

  Widget _monedaOption(String title, String price) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(price, style: TextStyle(color: Colors.green, fontSize: 16)),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Funció de compra encara no implementada')),
          );
        },
      ),
    );
  }
}
