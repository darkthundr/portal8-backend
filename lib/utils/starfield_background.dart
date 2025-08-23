import 'package:flutter/material.dart';

class StarfieldBackground extends StatelessWidget {
  final Widget child;

  const StarfieldBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color(0xFF1E0A3F), // Deep space purple
            Color(0xFF0D0518), // A darker, distant purple
          ],
        ),
      ),
      child: child,
    );
  }
}
