import '../imports.dart';

class SkinsListWidget extends StatelessWidget {
  final List<Skin> skins;

  const SkinsListWidget({Key? key, required this.skins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: 0.5,
      initialPage: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skins disponibles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: Align(
            alignment: Alignment.centerLeft,
            child: PageView.builder(
              controller: controller,
              itemCount: skins.length,
              padEnds:
                  false, // ← Esto es clave para que empiece en el borde izquierdo
              itemBuilder: (context, index) {
                final skin = skins[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (skin.imatge != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                skin.imatge!,
                                height: 93,
                                width: 93,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            skin.nom,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
