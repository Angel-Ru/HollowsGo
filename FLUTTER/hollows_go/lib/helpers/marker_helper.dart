import 'package:hollows_go/imports.dart';
import 'package:hollows_go/screens/combatvideoscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class MarkerHelper {
  static final Map<String, Uint8List> _iconCache = {};

  static Future<Uint8List> getMarkerIconFromUrl(String imageUrl,
      {bool shouldRound = false}) async {
    if (_iconCache.containsKey(imageUrl)) return _iconCache[imageUrl]!;

    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200)
        throw Exception("No es pot carregar la imatge");

      final ui.Codec codec =
          await ui.instantiateImageCodec(response.bodyBytes, targetWidth: 100);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      final iconBytes = await _processIcon(frameInfo.image, shouldRound);
      _iconCache[imageUrl] = iconBytes; // Cache
      return iconBytes;
    } catch (e) {
      print('Error carregant imatge des de URL: $e');
      rethrow;
    }
  }

  static Future<Uint8List> _processIcon(
      ui.Image image, bool shouldRound) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(100, 100);

    if (!shouldRound) {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    final path = Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.clipPath(path);
    final paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);

    final img = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<Set<Marker>> generateEnemyMarkers({
    required LatLng currentLocation,
    required BuildContext context,
    required List<String> imagePaths,
    required double radius,
  }) async {
    final Random random = Random();
    final int numPoints = random.nextInt(5) + 3;
    final List<Future<Marker?>> futures = [];

    for (int i = 0; i < numPoints; i++) {
      futures.add(
          _createEnemyMarker(i, currentLocation, radius, imagePaths, context));
    }

    final markers = await Future.wait(futures);
    return markers.whereType<Marker>().toSet();
  }

  static Future<Marker?> _createEnemyMarker(int index, LatLng currentLocation,
      double radius, List<String> imagePaths, BuildContext context) async {
    try {
      final Random random = Random();
      const double earthRadius = 6371000;

      double angle = random.nextDouble() * 2 * pi;
      double distance = sqrt(random.nextDouble()) * radius;
      double deltaLat = (distance / earthRadius) * (180 / pi);
      double deltaLng = (distance / earthRadius) *
          (180 / pi) /
          cos(currentLocation.latitude * pi / 180);

      LatLng randomPoint = LatLng(
        currentLocation.latitude + deltaLat * cos(angle),
        currentLocation.longitude + deltaLng * sin(angle),
      );

      String imgUrl = imagePaths[random.nextInt(imagePaths.length)];
      final Uint8List iconBytes = await getMarkerIconFromUrl(imgUrl);

      return Marker(
        markerId: MarkerId('enemy_$index'),
        position: randomPoint,
        infoWindow: InfoWindow(title: 'Enemic nº $index'),
        icon: BitmapDescriptor.fromBytes(iconBytes),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CombatIntroVideoScreen()),
          );
        },
      );
    } catch (e) {
      print('Error creant marcador enemic $index: $e');
      return null;
    }
  }

  static Future<Marker> buildCurrentUserMarker({
    required LatLng location,
    required String profileImageUrl,
  }) async {
    final Uint8List iconBytes =
        await getMarkerIconFromUrl(profileImageUrl, shouldRound: true);
    return Marker(
      markerId: MarkerId('currentLocation'),
      position: location,
      infoWindow: InfoWindow(title: 'Ubicació actual'),
      icon: BitmapDescriptor.fromBytes(iconBytes),
    );
  }
}
