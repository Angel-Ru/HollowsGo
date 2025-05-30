import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class AudioService {
  // Singleton
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  // Llistes de cançons per cada pantalla
  final List<String> _homeMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/zsjzvaaz2naidgksavjn',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/v75croefbl9pw2xum78x',
    // afegeix més URLs aquí
  ];

  final List<String> _tendaMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dq2skhigp8ml5kjysdl8',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/n47sbuwwhjntfd5tplpl',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/wqjoawsw8v7igikmuym4',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/nzvkinzhqcoor7hdb72n',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dtofpubrwmruyye4kajd',
    // afegeix més URLs aquí
  ];

  final Random _random = Random();

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

  /// Pausa l'àudio (fa stop per garantir que s'atura)
  Future<void> pause() async {
    if (_isPlaying) {
      _currentPosition = await _player.getCurrentPosition() ?? Duration.zero;
      await _player.stop();
      _isPlaying = false;
    }
  }

  /// Reprèn la reproducció des de la darrera posició
  Future<void> resume() async {
    if (_currentUrl != null && !_isPlaying) {
      await _player.play(UrlSource(_currentUrl!), position: _currentPosition);
      _isPlaying = true;
    }
  }

  /// Atura completament l'àudio i reinicia la posició
  Future<void> stop() async {
    await _player.stop();
    _currentPosition = Duration.zero;
    _isPlaying = false;
  }

  /// Allibera els recursos de l'àudio
  Future<void> dispose() async {
    await _player.dispose();
  }

  /// Realitza un fade out de l'àudio abans d'aturar-lo
  Future<void> fadeOut({Duration duration = const Duration(seconds: 1)}) async {
    if (!_isPlaying) return;

    const int steps = 10;
    final double stepVolume = _player.volume / steps;
    final int stepDuration = duration.inMilliseconds ~/ steps;

    for (int i = 0; i < steps; i++) {
      final newVolume = (_player.volume - stepVolume).clamp(0.0, 1.0);
      await _player.setVolume(newVolume);
      await Future.delayed(Duration(milliseconds: stepDuration));
    }

    await _player.stop();
    _player.setVolume(1.0); // Reset al volum per futures cançons
    _isPlaying = false;
    _currentPosition = Duration.zero;
  }

  // --- Funcions noves per reproduir música segons pantalla ---

  /// Reprodueix una cançó aleatòria de la llista de la home
  Future<void> playHomeMusic() async {
    final url = _homeMusicUrls[_random.nextInt(_homeMusicUrls.length)];
    await play(url);
  }

  /// Reprodueix una cançó aleatòria de la llista de la tenda
  Future<void> playTendaMusic() async {
    final url = _tendaMusicUrls[_random.nextInt(_tendaMusicUrls.length)];
    await play(url);
  }
}
