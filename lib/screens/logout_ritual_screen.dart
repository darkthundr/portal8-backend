import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutRitualScreen extends StatefulWidget {
  final bool deleteAccount;

  const LogoutRitualScreen({super.key, this.deleteAccount = false});

  @override
  State<LogoutRitualScreen> createState() => _LogoutRitualScreenState();
}

class _LogoutRitualScreenState extends State<LogoutRitualScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _symbolController;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _symbolController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      _symbolController.forward();
    });

    Future.delayed(const Duration(seconds: 3), () async {
      final auth = FirebaseAuth.instance;

      try {
        if (widget.deleteAccount) {
          await auth.currentUser?.delete();
        } else {
          await auth.signOut();
        }
      } catch (e) {
        // Handle errors (e.g. recent login required)
        debugPrint("Logout/Delete error: $e");
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _symbolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeController,
        child: Stack(
          children: [
            Center(
              child: ScaleTransition(
                scale: Tween(begin: 0.5, end: 1.5).animate(_symbolController),
                child: FadeTransition(
                  opacity: _symbolController,
                  child: Text(
                    '∞',
                    style: const TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.purpleAccent, blurRadius: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}