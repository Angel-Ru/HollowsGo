import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:hollows_go/imports.dart';

class AudioService with WidgetsBindingObserver {
  // Singleton
  static final AudioService instance = AudioService._internal();
  factory AudioService() => instance;

  AudioService._internal() {
    // Escoltar els canvis del cicle de vida de l'app
    WidgetsBinding.instance.addObserver(this);

    _player.onPlayerComplete.listen((event) async {
      if (_currentUrl != null) {
        await fadeOut(duration: Duration(milliseconds: 700));
        await play(_currentUrl!);
        await fadeIn(duration: Duration(milliseconds: 700));
      }
    });
  }

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _isFading = false;
  double _volume = 1.0;

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
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/mgka7srvn6yvqkf0ook3',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/kubs8yagdgzqrptb6qjv'
  ];

  final List<String> _perfilMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/PROFILE_MUSICA/dw9kzikmlmjr7lnin8cm',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/rvfjnxz13ep6axa8wucr',
  ];

  final List<String> _mapaMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/q3nndud9xavtsimfry7v',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/yqruspp5kdqyhvpxehmm',
  ];

  final List<String> _settingsMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/SETTINGS_MUSICA/u8ao6m5yyrxkpybgsdnh',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/SETTINGS_MUSICA/zf5tmvaczuto07gjup4t',
  ];

  final List<String> _amistatsMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/AMISTATS_MUSICA/tudeyopnovxc4khvlkoz',
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/TUTORIAL/w8ypnhjubsiytbjkdwmu',
  ];

  final List<String> _tutorialMusicUrls = [
    'https://res.cloudinary.com/dkcgsfcky/video/upload/f_auto:video,q_auto/v1/CONFIGURATIONSCREEN/TUTORIAL/gpubxi1cz98orj8muezc',
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
      WidgetsBinding.instance.removeObserver(this);
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
      case 'prehome':
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
      case 'settings':
        urls = _settingsMusicUrls;
        break;
      case 'amistat':
        urls = _amistatsMusicUrls;
        break;
      case 'tutorial':
        urls = _tutorialMusicUrls;
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('📱 App Lifecycle State: $state');
    if (state == AppLifecycleState.paused) {
      pause();
    } else if (state == AppLifecycleState.resumed) {
      resume();
    }
  }
}
