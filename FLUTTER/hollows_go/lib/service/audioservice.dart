import 'dart:math' as developer;

import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:hollows_go/imports.dart';

class AudioService {
  // Singleton
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;
  AudioService._internal() {
    _player.onPlayerComplete.listen((event) async {
      if (_currentUrl != null) {
        // Fer un fadeOut suau
        await fadeOut(duration: Duration(milliseconds: 700));
        // Tornar a reproduir la mateixa cançó i fer fadeIn suau
        await play(_currentUrl!);
        await fadeIn(duration: Duration(milliseconds: 700));
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _isFading = false; // bandera per controlar fades
  double _volume = 1.0; // Volum guardat manualment

  final List<String> _prehomeMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/v1745996030/MUSICA/fkgjkz7ttdqxqakacqsd.mp3',
  ];

  final List<String> _homeMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/zsjzvaaz2naidgksavjn',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/v75croefbl9pw2xum78x',
  ];

  final List<String> _tendaMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dq2skhigp8ml5kjysdl8',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/n47sbuwwhjntfd5tplpl',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/wqjoawsw8v7igikmuym4',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/nzvkinzhqcoor7hdb72n',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/TENDASCREEN/MUSICA/dtofpubrwmruyye4kajd',
  ];

  final List<String> _bibliotecaMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/zsjzvaaz2naidgksavjn',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/v75croefbl9pw2xum78x',
  ];

  final List<String> _perfilMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_MUSICA/dw9kzikmlmjr7lnin8cm',
  ];

  final List<String> _mapaMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/zsjzvaaz2naidgksavjn',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/HOMESCREEN/MUSICA/v75croefbl9pw2xum78x',
  ];

  final Random _random = Random();

  bool get isPlaying => _isPlaying;

  Future<void> play(String url) async {
    if (_isFading) {
      debugPrint('⚠️ Ignorant play() mentre es fa fadeOut');
      return;
    }
    try {
      if (_currentUrl != url || !_isPlaying) {
        debugPrint('▶️ Reproduint URL: $url');
        await _player.stop();
        _currentUrl = url;
        _currentPosition = Duration.zero;
        await _player.setVolume(_volume);
        await _player.play(UrlSource(url));
        _isPlaying = true;
      }
    } catch (e) {
      debugPrint('❌ Error a play(): $e');
    }
  }

  Future<void> pause() async {
    if (_isPlaying) {
      try {
        _currentPosition = await _player.getCurrentPosition() ?? Duration.zero;
        await _player.stop();
        _isPlaying = false;
      } catch (e) {
        debugPrint('❌ Error a pause(): $e');
      }
    }
  }

  Future<void> resume() async {
    if (_currentUrl != null && !_isPlaying) {
      try {
        await _player.setVolume(_volume);
        await _player.play(UrlSource(_currentUrl!), position: _currentPosition);
        _isPlaying = true;
      } catch (e) {
        debugPrint('❌ Error a resume(): $e');
      }
    }
  }

  Future<void> stop() async {
    try {
      debugPrint('🔇 AudioService: STOP cridat');
      debugPrint(StackTrace.current.toString());
      await _player.stop();
      _currentPosition = Duration.zero;
      _isPlaying = false;
    } catch (e) {
      debugPrint('❌ Error a stop(): $e');
    }
  }

  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (e) {
      debugPrint('❌ Error a dispose(): $e');
    }
  }

  Future<void> fadeOut({Duration duration = const Duration(seconds: 1)}) async {
    if (!_isPlaying || _isFading) return;

    _isFading = true;
    const int steps = 10;
    final double stepVolume = _volume / steps;
    final int stepDuration = duration.inMilliseconds ~/ steps;

    try {
      for (int i = 0; i < steps; i++) {
        _volume = (_volume - stepVolume).clamp(0.0, 1.0);
        await _player.setVolume(_volume);
        await Future.delayed(Duration(milliseconds: stepDuration));
      }

      await _player.stop();
      _volume = 1.0;
      await _player.setVolume(_volume);
      _isPlaying = false;
      _currentPosition = Duration.zero;
    } catch (e) {
      debugPrint('❌ Error a fadeOut(): $e');
    } finally {
      _isFading = false;
    }
  }

  Future<void> fadeIn({Duration duration = const Duration(seconds: 1)}) async {
    if (_isPlaying || _isFading) return;

    _isFading = true;
    const int steps = 10;
    final int stepDuration = duration.inMilliseconds ~/ steps;
    _volume = 0.0;
    await _player.setVolume(_volume);
    _isPlaying = true;

    try {
      for (int i = 0; i < steps; i++) {
        _volume = ((_volume + 1 / steps)).clamp(0.0, 1.0);
        await _player.setVolume(_volume);
        await Future.delayed(Duration(milliseconds: stepDuration));
      }
    } catch (e) {
      debugPrint('❌ Error a fadeIn(): $e');
    } finally {
      _volume = 1.0;
      _isFading = false;
    }
  }

  Future<void> playScreenMusic(String screen) async {
    List<String> urls;

    switch (screen) {
      case 'prehome': // 👈 afegit
        urls = _prehomeMusicUrls;
        break;
      case 'home':
        urls = _homeMusicUrls;
        break;
      case 'tenda':
        urls = _tendaMusicUrls;
        break;
      case 'perfil':
        urls = _perfilMusicUrls;
        break;
      case 'biblioteca':
        urls = _bibliotecaMusicUrls;
        break;
      case 'mapa':
        urls = _mapaMusicUrls;
        break;
      default:
        debugPrint('⚠️ playScreenMusic: pantalla desconeguda $screen');
        return;
    }

    final url = urls[_random.nextInt(urls.length)];
    debugPrint('🔊 playScreenMusic($screen) -> $url');

    if (_currentUrl == url && _isPlaying) {
      debugPrint('🔊 Ja s’està reproduint aquesta música');
      return;
    }

    if (_isPlaying) {
      await fadeOut();
    }
    await play(url);
  }
}
