import 'package:flutter/material.dart';
import 'package:hollows_go/providers/skins_enemics_personatges.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/perfil_provider.dart';
import '../../providers/map_provider.dart';
import '../../models/personatge.dart';

class HomeScreenController {
  final BuildContext context;

  HomeScreenController(this.context);

  Future<String> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) throw Exception("Usuari no trobat");

    final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);
    final mapProvider = Provider.of<MapDataProvider>(context, listen: false);

    final avatarUrl = await perfilProvider.obtenirAvatar(userId);

    // Només pre-càrrega de marcadors enemics, ja no es passa profileImagePath
    await mapProvider.preloadMapData(
      context: context,
      imagePaths: [
        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/miqna6lpshzrlfeewy1v.png',
        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/rf9vbqlqbpza3inl5syo.png',
        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/au1f1y75qc1aguz4nzze.png',
        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/rr49g97fcsrzg6n7r2un.png',
        'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/omchti7wzjbcdlf98fcl.png',
      ],
    );

    return avatarUrl;
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId == null) return;

    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);

    await provider.fetchPersonatgesAmbSkins(userId.toString());
    _precargarImagenes(provider.personatges);
    _precargarImagenes(provider.quincys);

    await provider.fetchEnemicsAmbSkins(userId.toString());
    _precargarImagenes(provider.characterEnemies);
  }

  void _precargarImagenes(List<Personatge> personatges) {
    for (var personatge in personatges) {
      for (var skin in personatge.skins) {
        final imageUrl = skin.imatge;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          CachedNetworkImageProvider(imageUrl).resolve(const ImageConfiguration());
        }
      }
    }
  }
}
