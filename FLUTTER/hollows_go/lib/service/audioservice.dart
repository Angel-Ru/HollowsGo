import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Singleton
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  /// Reprodueix una nova cançó o continua la mateixa si ja estava en ús
  Future<void> play(String url) async {
    if (_currentUrl != url) {
      await _player.stop();
      _currentUrl = url;
      _currentPosition = Duration.zero;
    }

    await _player.play(UrlSource(url));
    _isPlaying = true;
  }

  /// Pausa la cançó i guarda la posició actual
  Future<void> pause() async {
    if (_isPlaying) {
      _currentPosition = await _player.getCurrentPosition() ?? Duration.zero;
      await _player.pause();
      _isPlaying = false;
    }
  }

  /// Reprèn la reproducció des de la darrera posició
  Future<void> resume() async {
    if (_currentUrl != null && !_isPlaying) {
      await _player.seek(_currentPosition);
      await _player.resume();
      _isPlaying = true;
    }
  }

  /// Atura completament l'àudio
  Future<void> stop() async {
    await _player.stop();
    _currentPosition = Duration.zero;
    _isPlaying = false;
  }

  /// Allibera els recursos de l'àudio
  Future<void> dispose() async {
    await _player.dispose();
  }
}
