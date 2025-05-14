import 'package:hollows_go/imports.dart';

class MapDataProvider with ChangeNotifier {
  LatLng? _currentLocation;
  Set<Marker> _cachedMarkers = {};
  bool _isReady = false;

  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get cachedMarkers => _cachedMarkers;
  bool get isReady => _isReady;

  Future<void> preloadMapData({
    required String profileImagePath,
    required BuildContext context,
    required List<String> imagePaths,
    double radius = 250,
  }) async {
    try {
      // Verificación si profileImagePath no está vacío o nulo
      if (profileImagePath.isEmpty) {
        throw Exception("La URL de la imagen de perfil está vacía.");
      }

      // Opcional: Verificar si la URL es válida
      if (!Uri.parse(profileImagePath).isAbsolute) {
        throw Exception("La URL de la imagen de perfil no es válida.");
      }

      // Obtener la ubicación actual
      _currentLocation = await LocationHelper.getCurrentLocation();
      if (_currentLocation != null) {
        // Generación de los marcadores si la ubicación es válida
        _cachedMarkers = await MarkerHelper.generateMarkers(
          currentLocation: _currentLocation!,
          profileImagePath: profileImagePath,
          context: context,
          imagePaths: imagePaths,
          radius: radius,
        );
        _isReady = true;
        notifyListeners();
      }
    } catch (e) {
      // Manejo del error si algo falla
      print('Error preloading map data: $e');
    }
  }

  void reset() {
    _isReady = false;
    _currentLocation = null;
    _cachedMarkers = {};
    notifyListeners();
  }
}
