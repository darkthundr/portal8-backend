import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import color constants from your theme file
import 'package:portal8/utils/app_theme.dart';

// SplashScreen: A brief, elegant entry point for the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a brief loading period of 3 seconds.
    // After this, it uses GoRouter to navigate to the WelcomeScreen.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/welcome');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Use the cosmic background defined in your theme.
        decoration: kCosmicBackgroundDecoration,
        child: Center(
          child: Hero(
            // The Hero widget creates a fluid animation for the logo
            // as it moves from the splash screen to the login screen.
            tag: 'portal-logo',
            child: Text(
              'Portal 8',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: kPortalPurple.withOpacity(0.8),
                shadows: [
                  const Shadow(
                      color: kPortalPurple, blurRadius: 20, offset: Offset(0, 0))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
