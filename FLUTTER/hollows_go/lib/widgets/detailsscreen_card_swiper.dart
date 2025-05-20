import '../imports.dart';

class SkinsListWidget extends StatelessWidget {
  final List<Skin> skins;

  const SkinsListWidget({Key? key, required this.skins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController(
      viewportFraction: 0.48,
      initialPage: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skins disponibles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: Align(
            alignment: Alignment.centerLeft,
            child: PageView.builder(
              controller: controller,
              itemCount: skins.length,
              padEnds: false,
              itemBuilder: (context, index) {
                final skin = skins[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 78, 77, 77)
                          .withOpacity(0.50),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (skin.imatge != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                skin.imatge!,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            skin.nom,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
