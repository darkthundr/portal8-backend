import 'package:shared_preferences/shared_preferences.dart';

class TrialManager {
  static const String _trialUsedKey = 'trialUsed';

  /// Call this when user activates the trial (e.g. "Try Portal 0 Free" button)
  static Future<void> activateTrial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_trialUsedKey, true);
  }

  /// Check if trial is already used
  static Future<bool> hasUsedTrial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_trialUsedKey) ?? false;
  }

  /// Reset trial (only for dev/debug)
  static Future<void> resetTrial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_trialUsedKey);
  }
}
