import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import '../screens/portal_completion_screen.dart';
import '../widgets/session_card.dart';
//import 'portal_completion_screen.dart'; // ✅ Completion transition

class Portal0Screen extends StatefulWidget {
  final List<Chapter> sessions;

  const Portal0Screen({super.key, required this.sessions});

  @override
  State<Portal0Screen> createState() => _Portal0ScreenState();
}

class _Portal0ScreenState extends State<Portal0Screen> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void goToNextSession() {
    final isLast = currentIndex >= widget.sessions.length - 1;

    if (!isLast) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
      setState(() => currentIndex++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PortalCompletionScreen()),
      );
    }
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("🌀 Portal 0",
              style: TextStyle(fontSize: 20, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Session ${currentIndex + 1} of ${widget.sessions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.white54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Cosmic background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.black, Colors.deepPurple],
                  center: Alignment.topLeft,
                  radius: 1.5,
                ),
              ),
            ),
          ),

          // 🌀 Session swiper
          Column(
            children: [
              buildHeader(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.sessions.length,
                  physics: const NeverScrollableScrollPhysics(), // Controlled swipe
                  itemBuilder: (context, index) {
                    return SessionCard(
                      session: widget.sessions[index],
                      index: index,
                      onComplete: goToNextSession,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}