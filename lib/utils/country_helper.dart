import 'dart:io';

class CountryHelper {
  static Future<String> detectUserRegion() async {
    try {
      final locale = Platform.localeName; // e.g. "en_IN"
      if (locale.contains("IN")) {
        return "IN";
      }
    } catch (e) {
      // fallback to GLOBAL
    }
    return "GLOBAL";
  }
}
