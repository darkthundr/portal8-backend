import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

// ----------------- Enhanced Button Particles -----------------
class ButtonParticlePainterEnhanced extends CustomPainter {
  final double animationValue;
  final Random random = Random();

  ButtonParticlePainterEnhanced({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.08);
    for (int i = 0; i < 18; i++) {
      final angle = (animationValue * 2 * pi + i) % (2 * pi);
      final radius = 10 + i * 1.5;
      final x = size.width / 2 + cos(angle) * radius;
      final y = size.height / 2 + sin(angle) * radius;
      canvas.drawCircle(Offset(x, y), 1.5 + random.nextDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ---------------- Multi-layer Starfield ------------------
class MultiLayerStarPainter extends CustomPainter {
  final double progress;
  final Random random = Random();

  MultiLayerStarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final List<Map<String, dynamic>> layers = [
      {'count': 100, 'speed': 0.2, 'opacity': 0.05},
      {'count': 70, 'speed': 0.5, 'opacity': 0.08},
      {'count': 50, 'speed': 1.0, 'opacity': 0.1},
    ];

    for (var layer in layers) {
      final int count = layer['count'] as int;
      final double speed = layer['speed'] as double;
      final double opacity = layer['opacity'] as double;

      for (int i = 0; i < count; i++) {
        final x = (random.nextDouble() * size.width + progress * speed * size.width) % size.width;
        final y = (random.nextDouble() * size.height + progress * speed * size.height) % size.height;

        final paint = Paint()..color = Colors.white.withOpacity(opacity);
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MultiLayerStars extends StatelessWidget {
  final Animation<double> animation;
  final Size screenSize;

  const MultiLayerStars({super.key, required this.animation, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: screenSize,
      painter: MultiLayerStarPainter(animation.value),
    );
  }
}

// ----------------- Gradient Ritual Text -----------------
class RitualTextGradient extends StatefulWidget {
  final String text;
  final Duration delay;

  const RitualTextGradient({super.key, required this.text, required this.delay});

  @override
  State<RitualTextGradient> createState() => _RitualTextGradientState();
}

class _RitualTextGradientState extends State<RitualTextGradient> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [Colors.purpleAccent, Colors.blueAccent, Colors.pinkAccent],
              stops: [0.0, (_controller.value + 0.5) % 1, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }
}

// ----------------- HomeScreen -----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat();
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // 🌌 Multi-layer Starfield
              Positioned.fill(child: MultiLayerStars(animation: _controller, screenSize: size)),

              // ✨ Mystic Text
              Positioned(
                top: size.height * 0.15,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    RitualTextGradient(
                      text: "Welcome, Seeker of Truth",
                      delay: Duration(milliseconds: 500),
                    ),
                    SizedBox(height: 12),
                    RitualTextGradient(
                      text: "Beyond these 8 portals lies your escape from the Matrix.",
                      delay: Duration(seconds: 1),
                    ),
                    RitualTextGradient(
                      text: "Each unlock peels away an illusion, each scroll a revelation.",
                      delay: Duration(seconds: 2),
                    ),
                    RitualTextGradient(
                      text: "Pass through all 8, and the chains dissolve.",
                      delay: Duration(seconds: 3),
                    ),
                    RitualTextGradient(
                      text: "The Real begins where the Matrix ends.",
                      delay: Duration(seconds: 4, milliseconds: 500),
                    ),
                  ],
                ),
              ),

              // ✨ Shimmer Button
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: _shimmerButton(
                    label: "✨ Enter the Realm",
                    onTap: () => _showRitualModal(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 Shimmer button with glow
  Widget _shimmerButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final glow = sin(_controller.value * 2 * pi) * 10 + 20;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Glow
              Container(
                width: 260 + glow,
                height: 75 + glow / 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.purpleAccent.withOpacity(0.6),
                      Colors.blueAccent.withOpacity(0.6),
                      Colors.pinkAccent.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              // Particle Overlay
              CustomPaint(
                size: const Size(260, 70),
                painter: ButtonParticlePainterEnhanced(animationValue: _controller.value),
              ),
              // Main Button
              Container(
                width: 260,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // 🔹 Modal
  void _showRitualModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose the Journey which Unlocks Your Infinite Energy",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Low Energy? Feelin Burn-out,Stuck in thought Loops? Even Success feels empty?",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Escape From the Matrix,Through Immersively designed 8 portals or Directly Step into a Profound In-Person Energy Shift. ",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // 🔹 In-Person Immersion Options
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent.withOpacity(0.8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  onPressed: () => _showInPersonOptions(context),
                  child: const Text(
                    " In-Person shift",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 24),
                Stack(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      child: const Text(
                        "✨ Enter Portals Dashboard",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Free',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 In-Person Options Dialog
  void _showInPersonOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose Your Connection",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "3-day or 7-day premium offline experience,Starts from INR 3L  ",
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Few Insights",
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
//
                const Text(
                  " Feel Raw frequency of cosmic oneness, Feel and access Boundless Bliss from your Human System",
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Use Identification of Human Ego [ Iam -Your Name] as a sacred tool in life" ,
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _openUrl("https://forms.gle/56AWR7b3iz9bo9hT9"),
                  icon: const Icon(Icons.assignment, color: Colors.white),
                  label: const Text("Fill Google Form"),
                ),
                const SizedBox(height: 16),



                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _openUrl("https://wa.me/917569366854"),
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text("Chat on WhatsApp"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Helpers
  Future<void> _callNumber(String number) async {
    final url = 'tel:$number';
    if (await canLaunch(url)) await launch(url);
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
