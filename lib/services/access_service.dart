import 'package:cloud_firestore/cloud_firestore.dart';

class AccessService {
  static Future<bool> hasAdvancedAccess(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();

    if (data == null) return false;

    final unlocked = List<String>.from(data['unlockedPortals'] ?? []);

    final allPortals = List.generate(8, (i) => 'portal_${i + 1}');
    final hasAllPortals = allPortals.every((p) => unlocked.contains(p));
    final hasAdvancedPractices = unlocked.contains('advanced_practices');

    final legacyBundle = unlocked.contains('portal_infinity') && unlocked.contains('cosmic_theme');

    return hasAllPortals || hasAdvancedPractices || legacyBundle;
  }
}