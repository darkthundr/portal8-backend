import 'package:flutter/material.dart';

class PortalCompletionScreen extends StatefulWidget {
  const PortalCompletionScreen({super.key});

  @override
  State<PortalCompletionScreen> createState() => _PortalCompletionScreenState();
}

class _PortalCompletionScreenState extends State<PortalCompletionScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/dashboard'); // Or next portal
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.deepPurple, Colors.black],
                  center: Alignment.center,
                  radius: 1.2,
                ),
              ),
            ),
          ),
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.tealAccent, width: 4),
                  boxShadow: [
                    BoxShadow(color: Colors.tealAccent.withOpacity(0.5), blurRadius: 24),
                  ],
                ),
                child: const Center(
                  child: Text("Portal 0\nComplete",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.tealAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "🌟 You’ve passed through Portal 0\nThe next awaits...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    );
  }
}