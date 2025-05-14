import 'package:hollows_go/imports.dart';
import 'package:hollows_go/screens/combatvideoscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class MarkerHelper {
  static Future<Uint8List> getMarkerIcon(String imagePath, {bool shouldRound = false}) async {
    ByteData byteData = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    if (shouldRound) {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;
      const double radius = 50;

      canvas.drawCircle(const Offset(50, 50), radius, paint);
      paint.blendMode = BlendMode.srcIn;
      canvas.drawImage(frameInfo.image, const Offset(0, 0), paint);

      final ui.Image img = await pictureRecorder.endRecording().toImage(100, 100);
      final ByteData? imgBytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return imgBytes!.buffer.asUint8List();
    } else {
      final ByteData? imgBytes = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      return imgBytes!.buffer.asUint8List();
    }
  }

  /// Cargar una imatge des d'una URL (p. ex., des de Cloudinary)
  static Future<Uint8List> getMarkerIconFromUrl(String imageUrl, {bool shouldRound = false}) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) throw Exception("No es pot carregar la imatge");

      final Uint8List imageBytes = response.bodyBytes;
      ui.Codec codec = await ui.instantiateImageCodec(imageBytes, targetWidth: 100);
      ui.FrameInfo frameInfo = await codec.getNextFrame();

      if (shouldRound) {
        final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
        final Canvas canvas = Canvas(pictureRecorder);
        final Paint paint = Paint()..isAntiAlias = true;
        const double radius = 50;

        canvas.drawCircle(const Offset(50, 50), radius, paint);
        paint.blendMode = BlendMode.srcIn;
        canvas.drawImage(frameInfo.image, const Offset(0, 0), paint);

        final ui.Image img = await pictureRecorder.endRecording().toImage(100, 100);
        final ByteData? imgBytes = await img.toByteData(format: ui.ImageByteFormat.png);
        return imgBytes!.buffer.asUint8List();
      } else {
        final ByteData? imgBytes = await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
        return imgBytes!.buffer.asUint8List();
      }
    } catch (e) {
      print('Error carregant imatge des de URL: $e');
      rethrow;
    }
  }

  static Future<Set<Marker>> generateMarkers({
    required LatLng currentLocation,
    required String profileImagePath, // Cambiar a URL de la imatge
    required BuildContext context,
    required List<String> imagePaths,
    required double radius,
  }) async {
    Set<Marker> newMarkers = {};

    // Carregar la imatge de perfil des de la URL
    final Uint8List markerIcon = await getMarkerIconFromUrl(profileImagePath, shouldRound: true);

    // Crear un marcador amb la imatge de perfil
    newMarkers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentLocation,
        infoWindow: const InfoWindow(title: 'Ubicació actual'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );

    // Afegir més marcadors aleatoris
    final Random random = Random();
    const double earthRadius = 6371000;
    int numRandomPoints = random.nextInt(5) + 3;

    for (int i = 0; i < numRandomPoints; i++) {
      double randomAngle = random.nextDouble() * 2 * pi;
      double randomDistance = sqrt(random.nextDouble()) * radius;

      double deltaLat = (randomDistance / earthRadius) * (180 / pi);
      double deltaLng = (randomDistance / earthRadius) * (180 / pi) / cos(currentLocation.latitude * pi / 180);

      LatLng randomPoint = LatLng(
        currentLocation.latitude + deltaLat * cos(randomAngle),
        currentLocation.longitude + deltaLng * sin(randomAngle),
      );

      String randomImagePath = imagePaths[random.nextInt(imagePaths.length)];

      try {
        final Uint8List iconBytes = await getMarkerIconFromUrl(randomImagePath, shouldRound: false);

        newMarkers.add(
          Marker(
            markerId: MarkerId('random_$i'),
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

    return newMarkers;
  }
}
