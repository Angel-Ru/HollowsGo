import 'dart:async';
import 'package:hollows_go/providers/map_provider.dart';
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
  LatLng? _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  final double _radiusInMeters = 250;
  StreamSubscription<Position>? _positionStream;

  final List<String> imagePaths = [
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/miqna6lpshzrlfeewy1v.png',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/rf9vbqlqbpza3inl5syo.png',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/au1f1y75qc1aguz4nzze.png',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/rr49g97fcsrzg6n7r2un.png',
    'https://res.cloudinary.com/dkcgsfcky/image/upload/v1745249912/HOLLOWS_MAPA/omchti7wzjbcdlf98fcl.png',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSkinSelection());
    _initialize();
  }

  void _checkSkinSelection() {
    final provider = Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    if (provider.selectedSkinAliat == null) {
      PersonatgeNoSeleccionatDialog.mostrar(context);
    }
  }

  void _initialize() async {
    final mapProvider = Provider.of<MapDataProvider>(context, listen: false);

    if (mapProvider.isReady && mapProvider.currentLocation != null) {
      _currentLocation = mapProvider.currentLocation;
      _startLocationUpdates();
      final enemyMarkers = await MarkerHelper.generateEnemyMarkers(
        currentLocation: _currentLocation!,
        context: context,
        imagePaths: imagePaths,
        radius: _radiusInMeters,
      );

      setState(() {
        _markers.addAll(enemyMarkers);
        _isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      final LatLng newLocation = LatLng(position.latitude, position.longitude);
      final Marker userMarker = await MarkerHelper.buildCurrentUserMarker(
        location: newLocation,
        profileImageUrl: widget.profileImagePath,
      );

      setState(() {
        _currentLocation = newLocation;
        _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
        _markers.add(userMarker);
      });
    });
  }

  @override
  void didUpdateWidget(Mapscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileImagePath != widget.profileImagePath && _currentLocation != null) {
      _updateUserMarker();
    }
  }

  Future<void> _updateUserMarker() async {
    if (_currentLocation == null) return;

    final Marker updatedMarker = await MarkerHelper.buildCurrentUserMarker(
      location: _currentLocation!,
      profileImageUrl: widget.profileImagePath,
    );

    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
      _markers.add(updatedMarker);
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentLocation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final CameraPosition _puntInicial = CameraPosition(
      target: _currentLocation!,
      zoom: 15,
      tilt: 50,
    );

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true, 
            myLocationButtonEnabled: true,
            markers: _markers,
            mapType: _currentMapType,
            initialCameraPosition: _puntInicial,
            onMapCreated: (controller) {
              _controller.complete(controller);
              controller.setMapStyle(
                '[{"featureType":"poi","stylers":[{"visibility":"off"}]}]',
              );
            },
          ),
          Positioned(
            bottom: 25,
            right: 330,
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.layers, color: Colors.white),
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
