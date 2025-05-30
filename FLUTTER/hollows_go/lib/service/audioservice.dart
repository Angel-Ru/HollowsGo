import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import 'package:hollows_go/imports.dart';

class AudioService {
  // Singleton
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

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

  Future<void> play(String url) async {
    if (_currentUrl != url) {
      await _player.stop();
      _currentUrl = url;
      _currentPosition = Duration.zero;
    }

    await _player.play(UrlSource(url));
    _isPlaying = true;
  }

  Future<void> pause() async {
    if (_isPlaying) {
      _currentPosition = await _player.getCurrentPosition() ?? Duration.zero;
      await _player.stop();
      _isPlaying = false;
    }
  }

  Future<void> resume() async {
    if (_currentUrl != null && !_isPlaying) {
      await _player.play(UrlSource(_currentUrl!), position: _currentPosition);
      _isPlaying = true;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentPosition = Duration.zero;
    _isPlaying = false;
  }

  Future<void> dispose() async {
    await _player.dispose();
  }

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
    _player.setVolume(1.0);
    _isPlaying = false;
    _currentPosition = Duration.zero;
  }

  /// Reprodueix música segons la pantalla especificada
  Future<void> playScreenMusic(String screen) async {
    List<String> urls;

    switch (screen) {
      case 'home':
        urls = _homeMusicUrls;
        break;
      case 'tenda':
        urls = _tendaMusicUrls;
        break;
      default:
        return;
    }

    final url = urls[_random.nextInt(urls.length)];
    debugPrint('🔊 playScreenMusic($screen) -> $url');
    if (_currentUrl != url) {
      await fadeOut();
      await play(url);
    }
  }
}
