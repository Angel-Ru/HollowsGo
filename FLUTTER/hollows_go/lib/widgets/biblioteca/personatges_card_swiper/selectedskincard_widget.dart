import '../../../imports.dart';

class SelectedSkinCard extends StatelessWidget {
  final Skin skin;
  final bool isFavorite;
  final Function()? onFavoritePressed;
  final Function()? onHelpPressed;
  final Function()? onLongPress;
  final int? currentHealth;
  final int? maxHealth;

  const SelectedSkinCard({
    Key? key,
    required this.skin,
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onHelpPressed,
    this.onLongPress,
    this.currentHealth,
    this.maxHealth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final characterName = ''; // You might want to pass character name if needed

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Skin Seleccionada',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (onFavoritePressed != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onFavoritePressed,
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.grey,
                  size: 24,
                ),
              ),
            ],
            if (onHelpPressed != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onHelpPressed,
                child: const Icon(
                  Icons.help_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onLongPress: onLongPress,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orangeAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: Image.network(
                              skin.imatge ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                skin.nom,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  4,
                                  (index) => Icon(
                                    Icons.star,
                                    color: index < (skin.categoria ?? 0)
                                        ? Colors.yellow
                                        : Colors.grey,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
