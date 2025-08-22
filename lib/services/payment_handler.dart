import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Handles what happens after a successful payment
Future<void> handlePaymentSuccess({
  required BuildContext context,
  required List<String> unlocks,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    debugPrint("⚠️ No user logged in, cannot save payment.");
    return;
  }

  final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  try {
    // ✅ Save unlocks
    await userDoc.set({
      'unlocks': FieldValue.arrayUnion(unlocks),
    }, SetOptions(merge: true));

    // ✅ Save purchase history
    await userDoc.collection('purchases').add({
      'unlocks': unlocks,
      'timestamp': FieldValue.serverTimestamp(),
      'paymentMethod': 'Razorpay',
    });

    debugPrint("✅ Payment recorded for ${user.uid}");

    // ✅ Redirect based on purchase
    if (unlocks.contains('portal_infinity')) {
      Navigator.pushReplacementNamed(context, '/infinity_invocation');
    } else {
      Navigator.pushReplacementNamed(context, '/cosmic_nexus');
    }
  } catch (e, st) {
    debugPrint("❌ Error saving payment: $e");
    debugPrint(st.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error recording payment: $e")),
    );
  }
}

/// Checks if a user has unlocked a specific portal/item
Future<bool> hasUnlocked(String portalId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  final snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  final unlocks = List<String>.from(snap.data()?['unlocks'] ?? []);
  return unlocks.contains(portalId);
}
