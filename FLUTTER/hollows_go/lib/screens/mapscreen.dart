import 'dart:async';
import 'package:hollows_go/providers/map_provider.dart';
import 'package:hollows_go/service/audioservice.dart';
import '../imports.dart';

class Mapscreen extends StatefulWidget {
  final String profileImagePath;

  const Mapscreen({Key? key, required this.profileImagePath}) : super(key: key);

  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<Mapscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal; // Sempre normal
  LatLng? _currentLocation;
  bool _isLoading = true;
  Set<Marker> _markers = {};
  final double _radiusInMeters = 250;
  StreamSubscription<Position>? _positionStream;

  final List<String> imagePaths = [
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_miqna6lpshzrlfeewy1v.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_rf9vbqlqbpza3inl5syo.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_au1f1y75qc1aguz4nzze.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_rr49g97fcsrzg6n7r2un.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_omchti7wzjbcdlf98fcl.png?raw=true',
  ];

  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#0d0d0d"}]
  },
  {
    "elementType": "labels.icon",
    "stylers": [{"visibility": "off"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#e0e0e0"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#121212"}]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [{"color": "#1a1a1a"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#7a7a7a"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [{"color": "#101010"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#151515"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#a6a6a6"}]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [{"color": "#222222"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#292929"}]
  },
  {
    "featureType": "transit",
    "elementType": "geometry",
    "stylers": [{"color": "#1f1f1f"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#0b0b0b"}]
  }
]
''';

  @override
  void initState() {
    super.initState();
    AudioService.instance.playScreenMusic('mapa');
     WidgetsBinding.instance.addPostFrameCallback((_) => _checkSkinSelection());
    _initialize();
  }

  void _checkSkinSelection() {
    final provider =
        Provider.of<SkinsEnemicsPersonatgesProvider>(context, listen: false);
    if (provider.selectedSkinAliat == null && provider.selectedSkinEnemic == null && provider.selectedSkinQuincy == null) {
      PersonatgeNoSeleccionatDialog.mostrar(context);
    }
  }

  void _initialize() async {
    final mapProvider = Provider.of<MapDataProvider>(context, listen: false);

    if (mapProvider.isReady && mapProvider.currentLocation != null) {
      // Assignem la posició i mostrem el mapa ràpidament
      setState(() {
        _currentLocation = mapProvider.currentLocation;
        _isLoading = false;
      });

      _startLocationUpdates();

      // Carreguem els marcadors en background sense bloquejar UI
      MarkerHelper.generateEnemyMarkers(
        currentLocation: _currentLocation!,
        context: context,
        imagePaths: imagePaths,
        radius: _radiusInMeters,
      ).then((enemyMarkers) {
        setState(() {
          _markers.addAll(enemyMarkers);
        });
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
    if (oldWidget.profileImagePath != widget.profileImagePath &&
        _currentLocation != null) {
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
    if (_currentLocation == null) {
      // Esperem només la posició
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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
              controller.setMapStyle(_darkMapStyle);
            },
          ),
          // Aquí pots posar botons o altres widgets, si vols
        ],
      ),
    );
  }
}
