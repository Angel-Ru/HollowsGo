import '../imports.dart';
import 'dart:ui' as ui;

/*
Aquesta és la classe Mapscreen. En aquesta classe crea la pantalla del mapa de l'aplicació.
En aquesta pantalla es mostra un mapa de Google Maps amb la ubicació actual de l'usuari i uns punts aleatoris.
Aquests punts aleatoris són Hollows, els quals et duen a un combat contra un enemic.
Els Hollows generats són aleatoris i es mostren en un radi de 250 metres al voltant de la ubicació actual de l'usuari.
La generació de la quantitat de Hollows és aleatòria, entre 3 i 7. Igual que les imatges d'aquests.
El marcador de la ubicació actual de l'usuari és personalitzat amb la imatge de perfil que tengui posada.
*/

class Mapscreen extends StatefulWidget {
  final String profileImagePath;

  const Mapscreen({Key? key, required this.profileImagePath}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<Mapscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  LatLng _currentLocation = const LatLng(39.6084042, 2.8639693);
  bool _isLoading = true;
  Set<Marker> _markers = {};
  final double _radiusInMeters = 250;
  final List<String> imagePaths = [
    'lib/images/hollows/grandfisher.png',
    'lib/images/hollows/Cabezon.png',
    'lib/images/hollows/chepudo.png',
    'lib/images/hollows/menosgrande.png',
    'lib/images/hollows/volador.png'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void didUpdateWidget(Mapscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImagePath != widget.profileImagePath) {
      _updateMarkers();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw "Els serveis d'ubicació estan desactivats.";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw "Permisos d'ubicació denegats.";
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw "Permisos d'ubicació denegats permanentment.";
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      await _updateMarkers();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error obtenint l'ubicació: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateMarkers() async {
    Set<Marker> newMarkers = {};

    final Uint8List markerIcon =
        await _getMarkerIcon(widget.profileImagePath, shouldRound: true);
    newMarkers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation,
        infoWindow: const InfoWindow(title: 'Ubicació actual'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    );

    final Random random = Random();
    const double earthRadius = 6371000;
    int numRandomPoints = random.nextInt(5) + 3;

    for (int i = 0; i < numRandomPoints; i++) {
      double randomAngle = random.nextDouble() * 2 * pi;
      double randomDistance = sqrt(random.nextDouble()) * _radiusInMeters;

      double deltaLat = (randomDistance / earthRadius) * (180 / pi);
      double deltaLng = (randomDistance / earthRadius) *
          (180 / pi) /
          cos(_currentLocation.latitude * pi / 180);

      LatLng randomPoint = LatLng(
        _currentLocation.latitude + deltaLat * cos(randomAngle),
        _currentLocation.longitude + deltaLng * sin(randomAngle),
      );

      String randomImagePath = imagePaths[random.nextInt(imagePaths.length)];

      try {
        final Uint8List iconBytes =
            await _getMarkerIcon(randomImagePath, shouldRound: false);

        newMarkers.add(
          Marker(
            markerId: MarkerId('random_$i'),
            position: randomPoint,
            infoWindow: InfoWindow(title: 'Punt Aleatori $i'),
            icon: BitmapDescriptor.fromBytes(iconBytes),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CombatScreen()),
              );
            },
          ),
        );
      } catch (e) {
        print('Error al cargar la imagen para el marcador: $e');
      }
    }
    setState(() {
      _markers = newMarkers;
    });
  }

  Future<Uint8List> _getMarkerIcon(String imagePath,
      {bool shouldRound = false}) async {
    ByteData byteData = await rootBundle.load(imagePath);
    ui.Codec codec = await ui
        .instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    if (shouldRound) {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;
      final double radius = 50;

      canvas.drawCircle(const Offset(50, 50), radius, paint);
      paint.blendMode = BlendMode.srcIn;
      canvas.drawImage(frameInfo.image, const Offset(0, 0), paint);

      final ui.Image img =
          await pictureRecorder.endRecording().toImage(100, 100);
      final ByteData? imgBytes =
          await img.toByteData(format: ui.ImageByteFormat.png);
      return imgBytes!.buffer.asUint8List();
    } else {
      final ByteData? imgBytes =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      return imgBytes!.buffer.asUint8List();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _puntInicial = CameraPosition(
      target: _currentLocation,
      zoom: 15,
      tilt: 50,
    );

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: _markers,
                  mapType: _currentMapType,
                  initialCameraPosition: _puntInicial,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    controller.setMapStyle(
                        '[{"featureType":"poi","stylers":[{"visibility":"off"}]}]');
                  },
                ),
                Positioned(
                  bottom: 25,
                  right: 330,
                  child: FloatingActionButton(
                    backgroundColor: Colors.deepPurple,
                    child: const Icon(
                      Icons.layers,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentMapType = _currentMapType == MapType.normal
                            ? MapType.hybrid
                            : MapType.normal;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
