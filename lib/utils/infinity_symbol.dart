import 'package:flutter/material.dart';
import 'dart:math'; // For mathematical functions if needed in painter

// 🔁 Infinity Symbol with 8 Portals - Now a standalone utility widget
class InfinitySymbol extends StatelessWidget {
  const InfinitySymbol({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 300,
      child: CustomPaint(
        painter: InfinityPainter(),
        child: Stack(
          children: List.generate(8, (index) {
            // These calculations are for placing the "portals" along the infinity symbol.
            // You might need to adjust them slightly based on the exact path drawn by InfinityPainter
            // to make them sit perfectly on the line.
            final angle = (index / 8) * 2 * pi; // Use pi from dart:math
            final r = 60.0; // Radius for positioning
            // Adjusted x and y to better match the infinity symbol's path
            final x = 150 + (index < 4 ? -1 : 1) * r * (1 - (index % 4) / 3);
            final y = 100 + r * (index.isEven ? -1 : 1) * 0.6;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.cyanAccent : Colors.white24, // First portal is highlighted
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (index == 0) // Only the first portal glows
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.7),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// CustomPainter for drawing the infinity symbol path
class InfinityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24 // Color of the infinity line
      ..style = PaintingStyle.stroke // Draw only the outline
      ..strokeWidth = 2; // Thickness of the line

    final path = Path();
    // Start point of the infinity symbol
    path.moveTo(size.width * 0.25, size.height * 0.5);
    // First half of the infinity symbol (left loop)
    path.cubicTo(
      0, 0, // Control point 1 (top-left)
      0, size.height, // Control point 2 (bottom-left)
      size.width * 0.5, size.height * 0.5, // End point (center)
    );
    // Second half of the infinity symbol (right loop)
    path.cubicTo(
      size.width, 0, // Control point 1 (top-right)
      size.width, size.height, // Control point 2 (bottom-right)
      size.width * 0.75, size.height * 0.5, // End point (right)
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false; // No need to repaint if nothing changes
}
