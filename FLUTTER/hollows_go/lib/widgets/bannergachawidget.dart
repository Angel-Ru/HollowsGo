import '../imports.dart';

class GachaBannerWidget extends StatelessWidget {
  const GachaBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gachaProvider = Provider.of<GachaProvider>(context);

    return Column(
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
    );
  }
}
