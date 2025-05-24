import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../healthbarwidget.dart'; // ajusta el path segons la teva estructura
import '../../../models/skin.dart';  // assegura't d'importar el model correcte

class SkinCard extends StatelessWidget {
  final Skin skin;
  final bool isSelected;
  final bool isFavorite;
  final bool isEnemyMode;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onVialPressed;
  final Color activeColor;
  final Color borderColor;

  const SkinCard({
    Key? key,
    required this.skin,
    required this.isSelected,
    required this.isFavorite,
    required this.isEnemyMode,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onVialPressed,
    this.activeColor = Colors.orangeAccent,
    this.borderColor = const Color.fromRGBO(255, 165, 0, 0.6),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = _cleanSkinName(skin.nom, skin.personatgeNom ?? '');

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: GestureDetector(
        onTap: isEnemyMode ? null : onTap,
        onDoubleTap: isEnemyMode ? null : onDoubleTap,
        onLongPress: isEnemyMode ? null : onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[900],
              border: Border.all(
                color: isSelected ? activeColor : borderColor,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.7),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  // Imatge
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: skin.imatge ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Image.asset(
                          'assets/loading/loading.gif',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.error, color: Colors.redAccent),
                      ),
                    ),
                  ),
                  // Estrella favorita
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.yellow : Colors.grey,
                      size: 28,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black),
                      ],
                    ),
                  ),
                  // Check seleccionat
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.check_circle,
                          color: activeColor, size: 28),
                    ),
                  // Botó vial
                  if (!isEnemyMode)
                    Positioned(
                      bottom: 60,
                      left: 8,
                      child: GestureDetector(
                        onTap: onVialPressed,
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.healing, color: Colors.white),
                        ),
                      ),
                    ),
                  // Nom i estrelles
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName.isEmpty ? skin.nom : displayName,
                            style: TextStyle(
                              color: activeColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (i) {
                              return Icon(
                                Icons.star,
                                color: i < (skin.categoria ?? 0)
                                    ? Colors.yellow
                                    : Colors.grey,
                                size: 20,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _cleanSkinName(String skinName, String characterName) {
    if (skinName.toLowerCase().startsWith(characterName.toLowerCase())) {
      return skinName.substring(characterName.length).trim();
    }
    return skinName;
  }
}
