import 'package:flutter/material.dart';
import 'cosmic_nexus_screen.dart';

class RitualConfirmationScreen extends StatefulWidget {
  const RitualConfirmationScreen({super.key});

  @override
  State<RitualConfirmationScreen> createState() => _RitualConfirmationScreenState();
}

class _RitualConfirmationScreenState extends State<RitualConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CosmicNexusScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.auto_awesome, size: 80, color: Colors.purpleAccent),
            SizedBox(height: 24),
            Text(
              '🌟 Your offering is received.\nThe portal opens.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}