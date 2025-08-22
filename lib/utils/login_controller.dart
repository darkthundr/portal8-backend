import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Login with Email & Password
  Future<void> loginWithEmail(
      String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = userCredential.user;
      if (user != null && context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      switch (e.code) {
        case 'user-not-found':
          _showNoAccountDialog(context);
          break;
        case 'wrong-password':
          _showSnack(context, 'Incorrect sigil. Try again.');
          break;
        case 'invalid-email':
          _showSnack(context, 'Malformed email. Check your glyphs.');
          break;
        default:
          _showSnack(context, 'Login failed: ${e.message ?? "Unknown error"}');
      }
    } catch (e) {
      if (context.mounted) {
        _showSnack(context, 'Unexpected error: $e');
      }
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _showSnack(context, 'Google Sign-In cancelled.');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _createUserDocIfMissing(user);
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      debugPrint("Google Sign-In failed: $e");
      if (context.mounted) {
        _showSnack(context, 'Google Sign-In failed');
      }
    }
  }

  /// Create Firestore user doc if missing
  Future<void> _createUserDocIfMissing(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'joined': Timestamp.now(),
        'hasBundle': false,
        'allPortalsUnlocked': false,
        'infiniteScroll': false,
      });
    }
  }

  /// Show SnackBar
  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Show dialog for no account (signup)
  void _showNoAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1833),
        title: const Text("No Account Found",
            style: TextStyle(color: Colors.white)),
        content: const Text(
          "This email is not yet linked to a journey.\nWould you like to begin?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: const Text("Begin Journey",
                style: TextStyle(color: Colors.purpleAccent)),
          ),
        ],
      ),
    );
  }
}
