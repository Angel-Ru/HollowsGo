import '../imports.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({Key? key}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<Mapscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  LatLng _currentLocation = const LatLng(39.6084042, 2.8639693);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Los servicios de ubicación están desactivados.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permisos de ubicación denegados.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Permisos de ubicación denegados permanentemente.';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      print("Error obteniendo la ubicación: $e");
      setState(() {
        _isLoading = false;
      });
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
                  mapType: _currentMapType,
                  initialCameraPosition: _puntInicial,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
