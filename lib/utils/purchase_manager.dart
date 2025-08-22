import 'package:shared_preferences/shared_preferences.dart';
import 'trial_manager.dart';

class PurchaseManager {
  static const String _unlockedPortalsKey = 'unlockedPortals';
  static const String _chatSupportUnlockedKey = 'chatSupportUnlocked';

  /// Unlocks a portal (paid or trial)
  static Future<void> unlockPortal(int portalNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = await getUnlockedPortals();
    if (!unlocked.contains(portalNumber)) {
      unlocked.add(portalNumber);
      await prefs.setStringList(
        _unlockedPortalsKey,
        unlocked.map((e) => e.toString()).toList(),
      );
    }
  }

  /// Checks if portal is already unlocked (paid or trial)
  static Future<bool> isPortalUnlocked(int portalNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList(_unlockedPortalsKey) ?? [];
    return unlocked.contains(portalNumber.toString());
  }

  /// Returns list of unlocked portals
  static Future<List<int>> getUnlockedPortals() async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList(_unlockedPortalsKey) ?? [];
    return unlocked.map(int.parse).toList();
  }

  /// Unlock chat support
  static Future<void> unlockChatSupport() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chatSupportUnlockedKey, true);
  }

  /// Check if chat support is unlocked
  static Future<bool> isChatSupportUnlocked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_chatSupportUnlockedKey) ?? false;
  }

  /// For debugging: reset all unlocks
  static Future<void> resetPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_unlockedPortalsKey);
    await prefs.remove(_chatSupportUnlockedKey);
    await TrialManager.resetTrial();
  }
}
