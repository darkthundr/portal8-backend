import 'package:flutter/material.dart';

class FloatingGlyph extends StatelessWidget {
  final String symbol;
  final double size;
  final Offset start;
  final Offset end;
  final Duration duration;
  final Color color;

  const FloatingGlyph({
    required this.symbol,
    required this.size,
    required this.start,
    required this.end,
    required this.duration,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: start, end: end),
      duration: duration,
      curve: Curves.easeInOut,
      builder: (context, offset, child) {
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: Opacity(
            opacity: 0.6,
            child: Text(
              symbol,
              style: TextStyle(
                fontSize: size,
                color: color,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: color.withOpacity(0.5),
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}