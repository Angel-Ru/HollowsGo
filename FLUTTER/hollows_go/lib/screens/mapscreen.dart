import '../imports.dart';
import 'dart:ui' as ui;

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
  final double _radiusInMeters = 250; // Radio en metros

  final List<String> imagePaths = [
    'lib/images/hollows/grandfisher.png', // Asegúrate de poner las rutas correctas de las imágenes
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
      await _updateMarkers(); // Actualizar todos los marcadores
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
    // Crear un nuevo conjunto de marcadores
    Set<Marker> newMarkers = {};

    // Agregar el marcador de la ubicación actual
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

    // Agregar los marcadores aleatorios
    final Random random = Random();
    const double earthRadius = 6371000; // Radio de la Tierra en metros
    int numRandomPoints =
        random.nextInt(5) + 3; // Número de puntos aleatorios entre 5 y 10

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

      // Seleccionar aleatoriamente una imagen de la lista
      String randomImagePath = imagePaths[random.nextInt(imagePaths.length)];

      try {
        // Cargar la imagen sin redondear
        final Uint8List iconBytes =
            await _getMarkerIcon(randomImagePath, shouldRound: false);

        // Añadir el marcador con la imagen cargada
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

    // Actualizar el estado con los nuevos marcadores
    setState(() {
      _markers = newMarkers;
    });
  }

  // Modificar la función para aceptar un parámetro `shouldRound`
  Future<Uint8List> _getMarkerIcon(String imagePath,
      {bool shouldRound = false}) async {
    ByteData byteData = await rootBundle.load(imagePath);
    ui.Codec codec = await ui
        .instantiateImageCodec(byteData.buffer.asUint8List(), targetWidth: 100);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    if (shouldRound) {
      // Redondear la imagen solo si `shouldRound` es true
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
      // Devolver la imagen sin redondear
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
