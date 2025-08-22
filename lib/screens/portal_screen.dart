import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PortalScreen extends StatefulWidget {
  final String portalId;

  const PortalScreen({required this.portalId, Key? key}) : super(key: key);

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  List<dynamic> sessions = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final path = 'assets/portals/${widget.portalId}.json';
    print("📂 Loading sessions from: $path");

    try {
      final data = await rootBundle.loadString(path);
      final decoded = json.decode(data);
      setState(() {
        sessions = decoded['sessions'] ?? [];
        errorMessage = null;
      });
    } catch (e) {
      print("❌ Failed to load $path: $e");
      setState(() {
        errorMessage = "Could not load ${widget.portalId}.json.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: errorMessage != null
          ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 12),
            child: Text(
              "🌀 Welcome to ${widget.portalId.toUpperCase()}",
              style: GoogleFonts.montserrat(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
                shadows: [
                  const Shadow(
                    blurRadius: 12,
                    color: Colors.deepPurpleAccent,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 600),
                        pageBuilder: (_, __, ___) =>
                            SessionDetailScreen(session: session),
                        transitionsBuilder: (_, animation, __, child) {
                          final offset = Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation);
                          return SlideTransition(
                            position: offset,
                            child: FadeTransition(opacity: animation, child: child),
                          );
                        },
                      ),
                    );
                  },
                  child: AnimatedChapterCard(
                    title: session['title'] ?? 'Untitled',
                    teaser: session['hook'] ?? '',
                    delay: Duration(milliseconds: 100 * index),
                    color: Colors.primaries[index % Colors.primaries.length].shade700,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedChapterCard extends StatefulWidget {
  final String title;
  final String teaser;
  final Duration delay;
  final Color color;

  const AnimatedChapterCard({
    required this.title,
    required this.teaser,
    required this.delay,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<AnimatedChapterCard> createState() => _AnimatedChapterCardState();
}

class _AnimatedChapterCardState extends State<AnimatedChapterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: Card(
          color: widget.color,
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(widget.teaser,
                    style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SessionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> session;

  const SessionDetailScreen({required this.session, Key? key}) : super(key: key);

  Widget buildSection(String label, dynamic content, Color color) {
    if (content == null || content.toString().trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 6),
          content is List
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content
                .map<Widget>((item) => Text("• $item",
                style: GoogleFonts.montserrat(color: Colors.white)))
                .toList(),
          )
              : Text(content.toString(),
              style: GoogleFonts.montserrat(color: Colors.white)),
          const SizedBox(height: 12),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, Colors.transparent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(session['title'] ?? 'Session'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection("Hook", session['hook'], accent),
            buildSection("Story", session['story'], Colors.orangeAccent),
            buildSection("Guided Practice", session['guidedPractice'], Colors.lightBlueAccent),
            buildSection("Reflection", session['reflection'], Colors.greenAccent),
            buildSection("Micro Practice", session['microPractice'], Colors.amberAccent),
            buildSection("Scientific Note", session['scientificNote'], Colors.cyanAccent),
            buildSection("Cosmic Analogy", session['cosmicAnalogy'], Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}