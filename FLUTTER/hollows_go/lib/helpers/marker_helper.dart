import 'package:hollows_go/imports.dart';
import 'package:hollows_go/screens/combatvideoscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class MarkerHelper {
  /// Genera un Uint8List a partir d’una imatge local
  static Future<Uint8List> getMarkerIcon(String imagePath, {bool shouldRound = false}) async {
    ByteData byteData = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    return _processIcon(frameInfo.image, shouldRound);
  }

  /// Genera un Uint8List a partir d’una imatge en URL
  static Future<Uint8List> getMarkerIconFromUrl(String imageUrl, {bool shouldRound = false}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) throw Exception("No es pot carregar la imatge");

      final ui.Codec codec = await ui.instantiateImageCodec(response.bodyBytes, targetWidth: 100);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return _processIcon(frameInfo.image, shouldRound);
    } catch (e) {
      print('Error carregant imatge des de URL: $e');
      rethrow;
    }
  }

  /// Processa la imatge per aplicar format rodó si cal
  static Future<Uint8List> _processIcon(ui.Image image, bool shouldRound) async {
    if (!shouldRound) {
      final ByteData? imgBytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return imgBytes!.buffer.asUint8List();
    }

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..isAntiAlias = true;
    const double radius = 50;

    canvas.drawCircle(const Offset(50, 50), radius, paint);
    paint.blendMode = BlendMode.srcIn;
    canvas.drawImage(image, const Offset(0, 0), paint);

    final ui.Image finalImage = await recorder.endRecording().toImage(100, 100);
    final ByteData? byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Retorna un marcador personalitzat de perfil
  static Future<Marker> buildCurrentUserMarker({
    required LatLng location,
    required String profileImageUrl,
  }) async {
    final Uint8List iconBytes = await getMarkerIconFromUrl(profileImageUrl, shouldRound: true);
    return Marker(
      markerId: MarkerId('currentLocation'),
      position: location,
      infoWindow: InfoWindow(title: 'Ubicació actual'),
      icon: BitmapDescriptor.fromBytes(iconBytes),
    );
  }

  /// Genera marcadors aleatoris d’enemics al voltant
  static Future<Set<Marker>> generateEnemyMarkers({
    required LatLng currentLocation,
    required BuildContext context,
    required List<String> imagePaths,
    required double radius,
  }) async {
    Set<Marker> enemyMarkers = {};
    final Random random = Random();
    const double earthRadius = 6371000;
    int numPoints = random.nextInt(5) + 3;

    for (int i = 0; i < numPoints; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double distance = sqrt(random.nextDouble()) * radius;
      double deltaLat = (distance / earthRadius) * (180 / pi);
      double deltaLng = (distance / earthRadius) * (180 / pi) / cos(currentLocation.latitude * pi / 180);

      LatLng randomPoint = LatLng(
        currentLocation.latitude + deltaLat * cos(angle),
        currentLocation.longitude + deltaLng * sin(angle),
      );

      String imgUrl = imagePaths[random.nextInt(imagePaths.length)];

      try {
        final Uint8List iconBytes = await getMarkerIconFromUrl(imgUrl);
        enemyMarkers.add(
          Marker(
            markerId: MarkerId('enemy_$i'),
            position: randomPoint,
            infoWindow: InfoWindow(title: 'Punt Aleatori $i'),
            icon: BitmapDescriptor.fromBytes(iconBytes),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CombatIntroVideoScreen()),
              );
            },
          ),
        );
      } catch (_) {}
    }

    return enemyMarkers;
  }
}
