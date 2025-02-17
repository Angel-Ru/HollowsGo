import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'; // Paquete para obtener la ubicación

class Mapscreen extends StatefulWidget {
  const Mapscreen({Key? key}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<Mapscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal; // Tipo de mapa predeterminado
  LatLng _currentLocation =
      const LatLng(39.6084042, 2.8639693); // Ubicación inicial (Mallorca)
  bool _isLoading = true; // Para mostrar un indicador de carga

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Obtener la ubicación actual al iniciar la pantalla
  }

  // Método para obtener la ubicación actual
  Future<void> _getCurrentLocation() async {
    try {
      // Verifica si los permisos de ubicación están habilitados
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

      // Obtiene la ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Actualiza la ubicación en el estado
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

    Set<Marker> markers = <Marker>{};
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation,
        infoWindow: const InfoWindow(title: 'Tu ubicación'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.location_searching_sharp),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _currentLocation,
                    zoom: 15,
                    tilt: 50,
                    bearing: 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Indicador de carga
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true, // Muestra la ubicación del usuario
                  myLocationButtonEnabled:
                      true, // Botón para centrar en la ubicación
                  mapType: _currentMapType,
                  markers: markers,
                  initialCameraPosition: _puntInicial,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 25,
                  right: 330,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
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
