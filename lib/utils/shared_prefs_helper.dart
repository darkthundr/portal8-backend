import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static Future<void> setPaidUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPaidUser', value);
  }

  static Future<bool> isPaidUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPaidUser') ?? false;
  }

  static Future<void> setOnboardingSeen(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingSeen', value);
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboardingSeen') ?? false;
  }

  static Future<void> setFreeTrialUsed(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('freeTrialUsed', value);
  }

  static Future<bool> hasUsedFreeTrial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('freeTrialUsed') ?? false;
  }

  static Future<void> setCurrentAwakeningPercent(int percent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('awakeningPercent', percent);
  }

  static Future<int> getCurrentAwakeningPercent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('awakeningPercent') ?? 0;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
