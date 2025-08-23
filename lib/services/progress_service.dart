import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  static const String _progressKey = 'awakening_progress';
  static const String _unlockedPortalsKey = 'unlocked_portals';

  Future<void> setProgress(int percent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_progressKey, percent);
  }

  Future<int> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_progressKey) ?? 0;
  }

  Future<void> unlockPortal(int portalNumber) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unlocked = prefs.getStringList(_unlockedPortalsKey) ?? [];
    if (!unlocked.contains(portalNumber.toString())) {
      unlocked.add(portalNumber.toString());
      await prefs.setStringList(_unlockedPortalsKey, unlocked);
      await setProgress((unlocked.length / 8 * 100).toInt());
    }
  }

  Future<List<int>> getUnlockedPortals() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unlocked = prefs.getStringList(_unlockedPortalsKey) ?? [];
    return unlocked.map(int.parse).toList();
  }

  Future<bool> isPortalUnlocked(int portalNumber) async {
    final unlocked = await getUnlockedPortals();
    return unlocked.contains(portalNumber);
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_unlockedPortalsKey);
  }
}
