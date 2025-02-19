import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../imports.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

      setState(() async {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation,
            infoWindow: const InfoWindow(title: 'Ubicació actual'),
            icon: BitmapDescriptor.fromBytes(
                await _getMarkerIcon(widget.profileImagePath)),
          ),
        );
      });
    } catch (e) {
      print("Error obtenint l'ubicació: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _getMarkerIcon(String imagePath) async {
    ByteData byteData = await rootBundle.load(imagePath);
    return byteData.buffer.asUint8List();
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
