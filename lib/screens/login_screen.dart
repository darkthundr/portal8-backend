import 'dart:math';
import 'package:flutter/material.dart';

// Import your actual LoginController
import 'package:portal8/utils/login_controller.dart';
import 'package:portal8/screens/signup_screen.dart';

import '../utils/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginController = LoginController(); // ✅ Using your LoginController

  late AnimationController _bgController;
  late AnimationController _shimmerController;
  late AnimationController _swirlController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _swirlController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _shimmerController.dispose();
    _swirlController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ✅ Updated to use LoginController
  Future<void> loginWithEmail() async {
    await loginController.loginWithEmail(
      emailController.text.trim(),
      passwordController.text.trim(),
      context,
    );
  }

  // ✅ Updated to use LoginController
  Future<void> loginWithGoogle() async {
    await loginController.loginWithGoogle(context);
  }

  void _triggerRitualTransition() {
    _swirlController.forward().whenComplete(() {
      if (mounted) {
        Navigator.of(context).push(_fadeRoute(const SignupScreen()));
        _swirlController.reset();
      }
    });
  }

  Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 🌌 Animated Background
          AnimatedBuilder(
            animation: _bgController,
            builder: (_, __) {
              return Container(
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: FractionalOffset.center,
                    startAngle: 0.0,
                    endAngle: 2 * pi,
                    colors: const [
                      Color(0xFF30104A),
                      Color(0xFF2B1C6E),
                      Color(0xFF1E328A),
                      Color(0xFF195B7C),
                      Color(0xFF246B5A),
                      Color(0xFF4C7B3C),
                      Color(0xFF7B7231),
                      Color(0xFF9F592A),
                      Color(0xFF30104A),
                    ],
                    stops: List.generate(9, (i) => i / 8),
                    transform: GradientRotation(_bgController.value * 2 * pi),
                  ),
                ),
              );
            },
          ),

          // ✨ Floating Glyphs with swirl
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _swirlController,
              builder: (_, __) => CustomPaint(painter: _GlyphPainter(swirl: _swirlController)),
            ),
          ),

          // Blur overlay
          Container(color: Colors.black.withOpacity(0.4)),

          // 🧙‍♂️ Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter the Portal",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Your journey begins here.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),

                  _glowingTextField(emailController, "Email"),
                  const SizedBox(height: 20),
                  _glowingTextField(passwordController, "Password", obscure: true),
                  const SizedBox(height: 30),

                  _glowingButton("Login with Email", loginWithEmail),
                  const SizedBox(height: 16),
                  _glowingButton("Login with Google", loginWithGoogle,
                      icon: Icons.g_mobiledata, color: Colors.blueAccent),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ✨ Begin Journey Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signup'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        colors: [
                          Colors.pinkAccent,
                          Colors.orangeAccent,
                          Colors.purpleAccent,
                          Colors.blueAccent,
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                    },
                    child: const Text(
                      "✨ Don't have an account? Begin Your Journey",
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowingTextField(TextEditingController controller, String label, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purpleAccent.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _glowingButton(String label, VoidCallback onTap, {IconData? icon, Color color = Colors.purpleAccent}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 8,
        shadowColor: color.withOpacity(0.5),
        side: BorderSide(color: color),
      ),
    );
  }
}

// Painter for background swirl
class _GlyphPainter extends CustomPainter {
  final Animation<double> swirl;
  final Random _random = Random();

  _GlyphPainter({required this.swirl}) : super(repaint: swirl);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2));

    for (int i = 0; i < 40; i++) {
      final startAngle = _random.nextDouble() * 2 * pi;
      final angle = startAngle + (swirl.value * pi * (_random.nextBool() ? 1 : -1));

      final startRadius = _random.nextDouble() * maxRadius;
      final radius = startRadius - (swirl.value * startRadius);

      if (radius < 5) continue;

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final r = _random.nextDouble() * 3 + 1.0;

      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) => false;
}
