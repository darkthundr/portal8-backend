import 'package:flutter/material.dart';
import 'dart:math';

class PortalMap extends StatelessWidget {
  final List<bool> unlocked;
  final List<bool> completed;

  const PortalMap({super.key, required this.unlocked, required this.completed});

  @override
  Widget build(BuildContext context) {
    final radius = 120.0;
    final center = Offset(radius + 20, radius + 20);

    return SizedBox(
      width: radius * 2 + 40,
      height: radius * 2 + 40,
      child: Stack(
        children: List.generate(8, (i) {
          final angle = (2 * pi / 8) * i;
          final offset = Offset(
            center.dx + radius * cos(angle),
            center.dy + radius * sin(angle),
          );

          final glow = completed[i] ? Colors.tealAccent : unlocked[i] ? Colors.white : Colors.grey;
          final label = "P${i + 1}";

          return Positioned(
            left: offset.dx - 24,
            top: offset.dy - 24,
            child: GestureDetector(
              onTap: unlocked[i] ? () => print("Enter Portal ${i + 1}") : null,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glow.withOpacity(0.2),
                  border: Border.all(color: glow, width: 2),
                  boxShadow: completed[i]
                      ? [BoxShadow(color: glow, blurRadius: 12)]
                      : [],
                ),
                child: Center(
                  child: Text(label, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}