import '../imports.dart';

class SelectedSkinCard extends StatelessWidget {
  final Skin skin;

  const SelectedSkinCard({
    Key? key,
    required this.skin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
      children: [
        Center(
          // Centrar el texto horizontalmente
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Skin Seleccionada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                    child: ClipRRect(
                      child: Image.network(
                        skin.imatge ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${skin.nom} (Mal: ${skin.malTotal})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: index < (skin.categoria ?? 0)
                        ? Colors.yellow
                        : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
