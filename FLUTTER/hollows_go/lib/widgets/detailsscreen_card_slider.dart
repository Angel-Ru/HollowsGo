import '../imports.dart';

class SkinsListWidget extends StatelessWidget {
  final List<Skin> skins;

  const SkinsListWidget({Key? key, required this.skins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skins disponibles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: skins.map((skin) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: skin.imatge != null
                    ? Image.network(
                        skin.imatge!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(skin.nom),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
