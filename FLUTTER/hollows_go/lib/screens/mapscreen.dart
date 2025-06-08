import 'dart:async';
import 'package:hollows_go/providers/map_provider.dart';
import 'package:hollows_go/service/audioservice.dart';
import 'package:hollows_go/widgets/custom_loading_indicator.dart';
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
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/menos.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_rf9vbqlqbpza3inl5syo.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_au1f1y75qc1aguz4nzze.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_rr49g97fcsrzg6n7r2un.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/HOLLOWS_MAPA_omchti7wzjbcdlf98fcl.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/Hollows_generic1.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/Hollows_generic2.png?raw=true'
  ];

  final List<String> imagePathsQuincy = [
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/Meninaswebp.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/giselle.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/pngegg.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/YhwachBaseForm.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/Bleach_Ury%203F_Ishida_Anime_Schutztaffel_Render.png?raw=true',
    'https://github.com/MiquelSanso/Imatges-HollowsGO/blob/main/Mapa/Bleach_As_Nodt_Anime_Render.png?raw=true'
  ];

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
    if (provider.selectedSkinAliat == null &&
        provider.selectedSkinEnemic == null &&
        provider.selectedSkinQuincy == null) {
      PersonatgeNoSeleccionatDialog.mostrar(context);
    }
  }

  void _initialize() async {
    final mapProvider = Provider.of<MapDataProvider>(context, listen: false);

    if (mapProvider.isReady && mapProvider.currentLocation != null) {
      setState(() {
        _currentLocation = mapProvider.currentLocation;
        _isLoading = false;
      });

      _startLocationUpdates();

      final hour = DateTime.now().hour;
      final List<String> imagesToUse = (hour >= 7 && hour < 17)
          ? imagePathsQuincy
          : imagePaths;

      MarkerHelper.generateEnemyMarkers(
        currentLocation: _currentLocation!,
        context: context,
        imagePaths: imagesToUse,
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
      return const Scaffold(
        body: Center(child: CustomLoadingIndicator()),
      );
    }

    final CameraPosition _puntInicial = CameraPosition(
      target: _currentLocation!,
      zoom: 15,
      tilt: 50,
    );

    final int hour = DateTime.now().hour;
    final bool isNight = hour >= 17 || hour < 7;

    final String _dynamicMapStyle = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#0d0d0d' : '#ffffff'}"}]
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
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "${isNight ? '#292929' : '#f0f0f0'}"}]
      }
    ]
    ''';

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
              controller.setMapStyle(_dynamicMapStyle);
            },
          ),
        ],
      ),
    );
  }
}
