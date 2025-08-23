import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PortalUnlockService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Unlock a single portal
  Future<void> unlockPortal(String portalId) async {
    final user = _auth.currentUser;
    if (user == null) {
      print("❌ No user signed in");
      return;
    }

    final unlockRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('unlocks')
        .doc(portalId);

    await unlockRef.set({
      'unlocked': true,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print("✅ Portal unlocked: $portalId");
  }

  /// Unlock all 9 portals + ∞
  Future<void> unlockBundle() async {
    final portals = List.generate(9, (i) => 'portal$i');
    for (final portalId in portals) {
      await unlockPortal(portalId);
    }
    await unlockPortal('infinity');
    print("🌌 Bundle unlocked with ∞ portal");
  }

  /// Check if all 9 portals are unlocked
  Future<bool> allPortalsUnlocked() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final unlocksRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('unlocks');

    final snapshot = await unlocksRef.get();
    final unlockedIds = snapshot.docs.map((doc) => doc.id).toSet();

    final requiredPortals = List.generate(9, (i) => 'portal$i').toSet();
    final isComplete = requiredPortals.every(unlockedIds.contains);

    print("🔍 Unlock check: ${unlockedIds.length} portals found");
    return isComplete;
  }

  /// Conditionally unlock ∞ if all 9 are unlocked
  Future<void> maybeUnlockInfinity() async {
    final isComplete = await allPortalsUnlocked();
    if (isComplete) {
      await unlockPortal('infinity');
      print("🌌 ∞ portal unlocked");
    } else {
      print("⏳ Not all portals unlocked yet");
    }
  }
}