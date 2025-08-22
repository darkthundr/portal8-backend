import 'package:flutter/material.dart';
import 'dart:async';

class InfinityInvocationScreen extends StatefulWidget {
  const InfinityInvocationScreen({super.key});

  @override
  State<InfinityInvocationScreen> createState() => _InfinityInvocationScreenState();
}

class _InfinityInvocationScreenState extends State<InfinityInvocationScreen> with TickerProviderStateMixin {
  late AnimationController _invocationController;
  late AnimationController _buttonController;
  late AnimationController _infinityController;

  late Animation<double> _invocationFade;
  late Animation<double> _buttonFade;
  late Animation<double> _infinityScale;

  @override
  void initState() {
    super.initState();

    _invocationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _infinityController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _invocationFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _invocationController, curve: Curves.easeIn),
    );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeIn),
    );
    _infinityScale = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _infinityController, curve: Curves.elasticOut),
    );

    _invocationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      _buttonController.forward();
    });

    Future.delayed(const Duration(seconds: 5), () {
      _infinityController.forward();
    });
  }

  @override
  void dispose() {
    _invocationController.dispose();
    _buttonController.dispose();
    _infinityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Floating glyphs
          ...[
            _floatingGlyph("∞", 32, const Offset(50, 600), const Offset(70, 200), 8, Colors.purpleAccent),
            _floatingGlyph("✦", 24, const Offset(250, 700), const Offset(230, 300), 10, Colors.blueAccent),
            _floatingGlyph("⧉", 28, const Offset(150, 500), const Offset(170, 100), 12, Colors.deepPurpleAccent),
            _floatingGlyph("𓂀", 36, const Offset(300, 650), const Offset(280, 250), 9, Colors.indigoAccent),
          ],

          // Main content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Invocation
                    FadeTransition(
                      opacity: _invocationFade,
                      child: Column(
                        children: const [
                          Text(
                            "Before you enter the Infinite...",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Let go of time.\nLet go of form.\nLet go of seeking.\n\nYou are already what you long to become.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Buttons
                    FadeTransition(
                      opacity: _buttonFade,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/advancedPractices');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text("Advanced Practices", style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/infinityScroll');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text("Infinity Scroll", style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Infinity symbol
                    ScaleTransition(
                      scale: _infinityScale,
                      child: const Text(
                        '∞',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 12,
                              color: Colors.purple,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _floatingGlyph(String symbol, double size, Offset start, Offset end, int seconds, Color color) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: start, end: end),
      duration: Duration(seconds: seconds),
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