import 'package:hollows_go/imports.dart';

class MapDataProvider with ChangeNotifier {
  LatLng? _currentLocation;
  Set<Marker> _cachedEnemyMarkers = {};
  bool _isReady = false;
  bool _isLoading = false;
  String? _errorMessage;

  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get cachedMarkers => _cachedEnemyMarkers;
  bool get isReady => _isReady;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Precarrega la ubicació i marcadors.
  /// Retorna true si s’ha carregat correctament, false si no.
  Future<bool> preloadMapData({
    required BuildContext context,
    required List<String> imagePaths,
    double radius = 250,
  }) async {
    if (_isLoading) return false; // Evitar crides simultànies

    _isLoading = true;
    _isReady = false;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentLocation = await LocationHelper.getFastCurrentLocation(
        accuracy: LocationAccuracy.medium,
        timeoutSeconds: 5,
      );

      if (_currentLocation == null) {
        _errorMessage = 'No s’ha pogut obtenir la ubicació.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _cachedEnemyMarkers = await MarkerHelper.generateEnemyMarkers(
        currentLocation: _currentLocation!,
        context: context,
        imagePaths: imagePaths,
        radius: radius,
      );

      _isReady = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e, st) {
      print('Error preloading map data: $e\n$st');
      _errorMessage = 'Error carregant dades del mapa.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _currentLocation = null;
    _cachedEnemyMarkers = {};
    _isReady = false;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
