import 'package:shared_preferences/shared_preferences.dart';

class BonusManager {
  static Future<bool> isBundlePurchased() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('bundlePurchased') ?? false;
  }
}