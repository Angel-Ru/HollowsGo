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
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Musica/MUSICA_fkgjkz7ttdqxqakacqsd.mp3',
  ];

  final List<String> _homeMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/HomeScreen/Musica/HOMESCREEN_MUSICA_zsjzvaaz2naidgksavjn.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/HomeScreen/Musica/HOMESCREEN_MUSICA_v75croefbl9pw2xum78x.mp3',
  ];

  final List<String> _tendaMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Tenda/Musica/TENDASCREEN_MUSICA_dq2skhigp8ml5kjysdl8.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Tenda/Musica/TENDASCREEN_MUSICA_n47sbuwwhjntfd5tplpl.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Tenda/Musica/TENDASCREEN_MUSICA_wqjoawsw8v7igikmuym4.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Tenda/Musica/TENDASCREEN_MUSICA_nzvkinzhqcoor7hdb72n.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Tenda/Musica/TENDASCREEN_MUSICA_dtofpubrwmruyye4kajd.mp3',
  ];

  final List<String> _bibliotecaMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_kubs8yagdgzqrptb6qjv.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_wtj5tjwn4lziywibi7hs.mp3',
  ];

  final List<String> _perfilMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_PROFILE_MUSICA_dw9kzikmlmjr7lnin8cm.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_rvfjnxz13ep6axa8wucr.mp3',
  ];

  final List<String> _mapaMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_q3nndud9xavtsimfry7v.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_yqruspp5kdqyhvpxehmm.mp3',
  ];

  final List<String> _settingsMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_SETTINGS_MUSICA_u8ao6m5yyrxkpybgsdnh.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_SETTINGS_MUSICA_zf5tmvaczuto07gjup4t.mp3',
  ];

  final List<String> _amistatsMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_AMISTATS_MUSICA_tudeyopnovxc4khvlkoz.mp3',
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_TUTORIAL_w8ypnhjubsiytbjkdwmu.mp3',
  ];

  final List<String> _tutorialMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_TUTORIAL_gpubxi1cz98orj8muezc.mp3',
  ];

  final List<String> _editMusicUrls = [
    'https://media.githubusercontent.com/media/MiquelSanso/Imatges-HollowsGO/refs/heads/main/Configuration_Screen/CONFIGURATIONSCREEN_mgka7srvn6yvqkf0ook3.mp3',
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
      case 'edit':
        urls = _editMusicUrls;
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
