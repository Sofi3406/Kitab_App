import 'package:shared_preferences/shared_preferences.dart';

class AudioStateStorage {
  static const String _audioPathKey = 'last_audio_path';
  static const String _audioPositionKey = 'last_audio_position';

  static Future<void> saveAudioState(String audioPath, int position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_audioPathKey, audioPath);
    await prefs.setInt(_audioPositionKey, position);
  }

  static Future<Map<String, dynamic>?> loadAudioState() async {
    final prefs = await SharedPreferences.getInstance();
    final audioPath = prefs.getString(_audioPathKey);
    final position = prefs.getInt(_audioPositionKey);
    if (audioPath != null && position != null) {
      return {'audioPath': audioPath, 'position': position};
    }
    return null;
  }

  static Future<void> clearAudioState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_audioPathKey);
    await prefs.remove(_audioPositionKey);
  }
}
