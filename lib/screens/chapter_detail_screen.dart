import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chapter_model.dart';
import 'package:portal8/models/chapter_model.dart'; // Portal 0
import 'next_chapter_screen.dart'; // Replace with your actual next screen

class ChapterDetailScreen extends StatefulWidget {
  final LegacyChapter chapter;

  const ChapterDetailScreen({super.key, required this.chapter});

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _typeController;
  late Animation<double> _pulseAnimation;
  String teaserText = "";
  int teaserIndex = 0;

  late List<bool> ritualCompletion;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    final totalSteps = widget.chapter.rituals.length;
    ritualCompletion = List<bool>.filled(totalSteps, false);

    _initPrefs();
    _initAnimations();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < ritualCompletion.length; i++) {
      ritualCompletion[i] = prefs.getBool("chapter_${widget.chapter.id}_ritual_$i") ?? false;
    }
    setState(() {});
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _typeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
      if (teaserIndex < widget.chapter.teaser.length) {
        setState(() {
          teaserText += widget.chapter.teaser[teaserIndex];
          teaserIndex++;
        });
      } else {
        _typeController.stop();
      }
    });

    _typeController.repeat(period: const Duration(milliseconds: 50));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Widget buildRitualCard(String step, int index) {
    final isCompleted = ritualCompletion[index];

    return GestureDetector(
      onTap: () async {
        ritualCompletion[index] = !isCompleted;
        await prefs.setBool("chapter_${widget.chapter.id}_ritual_$index", ritualCompletion[index]);
        setState(() {});
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.8, end: 1.0),
        duration: Duration(milliseconds: 500 + index * 100),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.teal : Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  if (isCompleted)
                    BoxShadow(color: Colors.tealAccent, blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Text("• $step", style: const TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    final completedSteps = ritualCompletion.where((c) => c).length;
    final totalSteps = ritualCompletion.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 16),

                Text(chapter.title,
                    style: const TextStyle(fontSize: 28, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                Text(teaserText,
                    style: const TextStyle(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic)),
                const SizedBox(height: 24),

                AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(seconds: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("📖 Story",
                          style: TextStyle(fontSize: 20, color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(chapter.content, style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text("🌌 Ritual Practice",
                    style: TextStyle(fontSize: 20, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...chapter.rituals.asMap().entries.map((e) => buildRitualCard(e.value, e.key)),

                const SizedBox(height: 24),
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("💓 Reflection",
                          style: TextStyle(fontSize: 20, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(chapter.emotionalCheckpoint, style: const TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text("🌐 Community Prompt",
                    style: TextStyle(fontSize: 20, color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(chapter.communityPrompt, style: const TextStyle(color: Colors.white70)),

                const SizedBox(height: 24),
                const Text("🌀 Closing Whisper",
                    style: TextStyle(fontSize: 20, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.tealAccent, Colors.white],
                  ).createShader(bounds),
                  child: Text(
                    chapter.closingWhisper,
                    style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),

                const SizedBox(height: 32),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}