import 'dart:math';
import 'package:flutter/material.dart';

class SignupRitualScreen extends StatefulWidget {
  const SignupRitualScreen({super.key});

  @override
  State<SignupRitualScreen> createState() => _SignupRitualScreenState();
}

class _SignupRitualScreenState extends State<SignupRitualScreen> with TickerProviderStateMixin {
  late AnimationController _swirlController;
  late AnimationController _infinityController;
  late AnimationController _glyphController;

  @override
  void initState() {
    super.initState();

    _swirlController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _infinityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _glyphController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _swirlController.forward().then((_) {
      _infinityController.forward().then((_) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        });
      });
    });
  }

  @override
  void dispose() {
    _swirlController.dispose();
    _infinityController.dispose();
    _glyphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _glyphController,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    startAngle: 0.0,
                    endAngle: 2 * pi,
                    colors: [
                      Colors.deepPurple.shade900,
                      Colors.indigo.shade900,
                      Colors.black,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    transform: GradientRotation(_glyphController.value * 2 * pi),
                  ),
                ),
              );
            },
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),
          Positioned.fill(child: CustomPaint(painter: _GlyphPainter())),
          Center(
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_swirlController),
              child: CustomPaint(
                painter: _SwirlPainter(),
                size: const Size(200, 200),
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _infinityController,
              child: const Text(
                '∞',
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.purpleAccent, blurRadius: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (double i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        angle,
        pi / 6,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlyphPainter extends CustomPainter {
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 60; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      final radius = _random.nextDouble() * 2 + 0.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}