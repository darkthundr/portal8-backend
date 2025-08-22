import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> load(String assetPath) async {
    await _audioPlayer.setSource(AssetSource(assetPath));
    _isPlaying = false;
  }

  static Future<void> play() async {
    if (!_isPlaying) {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  static Future<void> pause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _isPlaying = false;
    }
  }

  static Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  static bool get isPlaying => _isPlaying;
}
