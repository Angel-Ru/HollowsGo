import 'package:hollows_go/imports.dart';

class MapDataProvider with ChangeNotifier {
  LatLng? _currentLocation;
  Set<Marker> _cachedEnemyMarkers = {};
  bool _isReady = false;

  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get cachedMarkers => _cachedEnemyMarkers;
  bool get isReady => _isReady;

  Future<void> preloadMapData({
    required BuildContext context,
    required List<String> imagePaths,
    double radius = 250,
  }) async {
    try {
      // Obtenir la ubicació actual
      _currentLocation = await LocationHelper.getCurrentLocation();

      if (_currentLocation != null) {
        // Generar marcadors aleatoris (enemics)
        _cachedEnemyMarkers = await MarkerHelper.generateEnemyMarkers(
          currentLocation: _currentLocation!,
          context: context,
          imagePaths: imagePaths,
          radius: radius,
        );

        _isReady = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error preloading map data: $e');
    }
  }

  void reset() {
    _isReady = false;
    _currentLocation = null;
    _cachedEnemyMarkers = {};
    notifyListeners();
  }
}
