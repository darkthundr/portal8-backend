import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import color constants from your theme file
import 'package:portal8/utils/app_theme.dart';
// Note: You might need to adjust the path to your PortalsMapScreen if it's in a different location.
import 'package:portal8/screens/dashboard_screen.dart';


// WelcomeScreen: A visually immersive entry with Google Sign-in.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to Portals Map
      // Note: Using GoRouter's `go` method for consistent navigation flow
      if (context.mounted) {
        context.go('/dashboard');
      }

    } catch (e) {
      // Handle sign-in errors gracefully
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kCosmicBackgroundDecoration,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Placeholder for a dynamic cosmic animation (e.g., a nebula)
                const SizedBox(height: 100),
                Text(
                  'Are You Ready to Exit the Matrix?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () => _signInWithGoogle(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    decoration: BoxDecoration(
                      color: kStarlightBlue,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: kStarlightBlue.withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Text(
                      'Enter Portal',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: kCosmicBlack, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
