import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  /// Intenta retornar la última ubicació coneguda ràpidament.
  /// Si no n'hi ha, demana la posició actual amb precisió mitjana i un timeout.
  /// Retorna null si no es pot obtenir cap ubicació.
  static Future<LatLng?> getFastCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.medium,
    int timeoutSeconds = 5,
  }) async {
    try {
      // 1. Comprova si el servei d’ubicació està activat
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // No podem fer res si el servei està desactivat
        print('Location services are disabled.');
        return null;
      }

      // 2. Comprova permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission is denied.');
          return null;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print('Location permission is permanently denied.');
        return null;
      }

      // 3. Intenta agafar l’última ubicació coneguda (pot ser molt ràpid)
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        return LatLng(lastPosition.latitude, lastPosition.longitude);
      }

      // 4. Si no hi ha última posició, demana la posició actual amb precisió mitjana
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
      ).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Timeout obtenint ubicació');
        },
      );

      return LatLng(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      print('Error obtenint ubicació o timeout: $e');
      return null;
    }
  }
}
