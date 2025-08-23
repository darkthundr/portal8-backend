import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chapter.dart';

class ChapterScreen extends StatefulWidget {
  final Chapter chapter;

  const ChapterScreen({required this.chapter, super.key});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> with TickerProviderStateMixin {
  List<bool> _visibleSections = List.filled(7, false);
  late AnimationController _particleController;
  late List<Offset> _particlePositions;

  final sectionColors = [
    Colors.pinkAccent,
    Colors.orangeAccent,
    Colors.lightBlueAccent,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.cyanAccent,
    Colors.purpleAccent,
  ];

  final stepColors = [Colors.white70, Colors.tealAccent];

  @override
  void initState() {
    super.initState();
    _animateSections();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _particlePositions = List.generate(
      40,
          (index) => Offset(
        50 + (index * 15.0) % 300,
        80 + (index * 25.0) % 600,
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  void _animateSections() async {
    for (int i = 0; i < _visibleSections.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _visibleSections[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Hero(
          tag: chapter.title,
          child: Text(
            chapter.title,
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
          ),
        ),
        backgroundColor: Colors.deepPurple.shade900,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 🌌 Enhanced Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A0033),
                  Color(0xFF0D1B2A),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),

          // ✨ Multicolor Particle Overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    _particlePositions.map((pos) {
                      final dx = pos.dx + 5 * (_particleController.value - 0.5);
                      final dy = pos.dy + 3 * (_particleController.value - 0.5);
                      return Offset(dx, dy);
                    }).toList(),
                    _particleController.value,
                  ),
                );
              },
            ),
          ),

          // 📜 Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: MediaQuery.of(context).size.height * 0.05,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _animatedSection(0, "🪞 Hook", chapter.hook),
                  _animatedSection(1, "📖 Story", chapter.story),
                  _animatedGuidedPractice(2),
                  _animatedSection(3, "🧘 Reflection", chapter.reflection),
                  _animatedSection(4, "🧪 Micro Practice", chapter.microPractice),
                  _animatedSection(5, "🧠 Scientific Note", chapter.scientificNote),
                  _animatedSection(6, "🌌 Cosmic Analogy", chapter.cosmicAnalogy),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedSection(int index, String title, String content) {
    final color = sectionColors[index % sectionColors.length];

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _visibleSections[index] ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        offset: _visibleSections[index] ? Offset.zero : const Offset(0, 0.1),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 8),
              Text(content,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.6,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animatedGuidedPractice(int index) {
    final steps = widget.chapter.guidedPractice;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _visibleSections[index] ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 600),
        offset: _visibleSections[index] ? Offset.zero : const Offset(0, 0.1),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🌀 Guided Practice",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    color: Colors.lightBlueAccent,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 12),
              ...steps.asMap().entries.map((entry) {
                final i = entry.key;
                final step = entry.value;
                final color = stepColors[i % stepColors.length];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${i + 1}. ",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                    Expanded(
                      child: Text(step,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: color,
                            height: 1.5,
                          )),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// 🌠 Multicolor Particle Painter
class ParticlePainter extends CustomPainter {
  final List<Offset> positions;
  final double shimmer;

  ParticlePainter(this.positions, this.shimmer);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
    ];

    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final color = colors[i % colors.length].withOpacity(0.05 + shimmer * 0.1);

      final glowPaint = Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      final paint = Paint()
        ..color = color.withOpacity(0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, 3.5, glowPaint);
      canvas.drawCircle(pos, 2.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}