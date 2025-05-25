class SpecialAnimationConfig {
  final String bankaiText;
  final String audioAsset;

  SpecialAnimationConfig({
    required this.bankaiText,
    required this.audioAsset,
  });
}

class SpecialAnimationService {
  static final Map<String, SpecialAnimationConfig> _configMap = {
    'yamamoto': SpecialAnimationConfig(
      bankaiText: 'Bankai',
      audioAsset: 'special_attack/yamamoto/yamamoto_aud.mp3',
    ),
    'gin': SpecialAnimationConfig(
      bankaiText: 'Kamishini no Yari',
      audioAsset: 'special_attack/gin/gin_aud.mp3',
    ),
    'shinji': SpecialAnimationConfig(
      bankaiText: 'Yokoso, sakasama no sekai',
      audioAsset: 'special_attack/shinji/shinji_aud.mp3',
    ),
  };

  static SpecialAnimationConfig? getConfigForSkin(Map<String, dynamic> skin) {
    final videoPath = skin['video_especial'];
    if (videoPath == null) return null;

    final segments = videoPath.toString().split('/');
    if (segments.length < 3) return null;

    final folder = segments[2]; // p. ex: 'yamamoto' dins 'assets/special_attack/yamamoto/...'
    return _configMap[folder];
  }
}
