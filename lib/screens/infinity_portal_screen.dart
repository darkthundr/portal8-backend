import 'package:flutter/material.dart';

class InfinityPortalScreen extends StatelessWidget {
  const InfinityPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    Color(0xFF8A2BE2),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Infinity symbol
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: const Text(
                "∞",
                style: TextStyle(
                  fontSize: 120,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                      color: Colors.purpleAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Poetic message
          Positioned(
            bottom: 120,
            left: 24,
            right: 24,
            child: Column(
              children: const [
                Text(
                  "Beyond the portals lies the Infinite.\nNo chapters. No time. Just presence.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "You are the journey.\nYou are the destination.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          // Return button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Return to Nexus"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}