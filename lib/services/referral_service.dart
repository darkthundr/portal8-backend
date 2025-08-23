import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReferralService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Ensure user has a referral profile (called at sign-in).
  Future<void> ensureReferralProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = _db.collection('users').doc(uid);
    final snap = await doc.get();
    if (!snap.exists) {
      await doc.set({
        'referralCode': _shortCode(uid),
        'referredBy': null,
        'referralCredits': 0,
        'hasReferralFree': false, // free purchase eligibility
        'unlockedPortals': [],
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      // backfill missing fields
      final data = snap.data() ?? {};
      final updates = <String, dynamic>{};
      if ((data['referralCode'] ?? '').toString().isEmpty) {
        updates['referralCode'] = _shortCode(uid);
      }
      if (!data.containsKey('referralCredits')) {
        updates['referralCredits'] = 0;
      }
      if (!data.containsKey('hasReferralFree')) {
        updates['hasReferralFree'] = false;
      }
      if (updates.isNotEmpty) {
        await doc.set(updates, SetOptions(merge: true));
      }
    }
  }

  /// Apply a referral code for current user (only once).
  /// Returns a user-friendly message (success or reason).
  Future<String> applyReferralCode(String code) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Not signed in';

    final userDoc = _db.collection('users').doc(uid);
    final userSnap = await userDoc.get();
    final userData = userSnap.data() ?? {};

    if ((userData['referredBy'] ?? '') != null) {
      return 'Referral code already applied.';
    }

    // find referrer by referralCode
    final refQuery = await _db
        .collection('users')
        .where('referralCode', isEqualTo: code.trim())
        .limit(1)
        .get();

    if (refQuery.docs.isEmpty) return 'Invalid referral code.';
    final referrer = refQuery.docs.first;
    final referrerUid = referrer.id;

    if (referrerUid == uid) return 'You cannot use your own code.';

    // set referredBy + give free eligibility
    await userDoc.set({
      'referredBy': referrerUid,
      'hasReferralFree': true,
      'referralAppliedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return 'Referral applied! You can unlock your first item for free.';
  }

  /// Consume the free unlock for current user, and reward the referrer.
  /// productId example: 'portal_1', 'bundle' (you decide policy)
  Future<String> consumeReferralFreeAndUnlock(String productId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Not signed in';

    return _db.runTransaction((txn) async {
      final userRef = _db.collection('users').doc(uid);
      final userSnap = await txn.get(userRef);
      if (!userSnap.exists) return 'User not found.';
      final data = userSnap.data() ?? {};

      final hasFree = (data['hasReferralFree'] ?? false) == true;
      if (!hasFree) return 'No free unlock available.';

      final List unlocked = List.from(data['unlockedPortals'] ?? []);
      if (productId.startsWith('portal_')) {
        if (!unlocked.contains(productId)) {
          unlocked.add(productId);
        }
      } else {
        // If you want the free to apply only to Portal 1, enforce here
        // return 'Free unlock is only valid for Portal 1.';
        // Or allow bundle (uncommon). We'll default to portal-only:
        return 'Free unlock is only valid for individual portals.';
      }

      // consume free
      txn.set(userRef, {
        'unlockedPortals': unlocked,
        'hasReferralFree': false,
        'lastFreeConsumedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // reward referrer
      final referrerUid = data['referredBy'];
      if (referrerUid != null && referrerUid.toString().isNotEmpty) {
        final refRef = _db.collection('users').doc(referrerUid);
        txn.set(refRef, {
          'referralCredits': FieldValue.increment(1),
          'lastReferralCreditAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      return 'Unlocked for free via referral!';
    });
  }

  /// Helper: make a short, shareable code from uid
  String _shortCode(String uid) {
    // Take last 6 chars uppercased; you can improve to base36 etc.
    final s = uid.replaceAll('-', '');
    final cut = s.length >= 6 ? s.substring(s.length - 6) : s.padLeft(6, 'X');
    return cut.toUpperCase();
  }
}
