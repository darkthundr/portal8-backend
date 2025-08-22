import 'package:flutter/material.dart';

class CosmicLoadingOverlay extends StatelessWidget {
  final String message;

  const CosmicLoadingOverlay({super.key, this.message = 'Aligning your portals...'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: Stack(
        children: [
          // Cosmic gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF3A0CA3),
                  Color(0xFF7209B7),
                  Color(0xFF4361EE),
                  Colors.black,
                ],
              ),
            ),
          ),

          // Swirling glyph (replace with Lottie or SVG if desired)
          const Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: CircularProgressIndicator(
                strokeWidth: 6,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),

          // Ritual message
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontFamily: 'Cinzel',
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}