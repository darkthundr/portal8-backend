import 'package:flutter/material.dart';
import '../data/portal0_chapters.dart';
import '../models/chapter_model.dart';
import 'chapter_detail_screen.dart';

class Portal0ChapterSwiper extends StatelessWidget {
  const Portal0ChapterSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Portal 0: THE SPARK"),
        backgroundColor: Colors.deepPurple.shade900,
        elevation: 4,
        shadowColor: Colors.deepPurpleAccent,
      ),
      body: PageView.builder(
        itemCount: portal0Chapters.length,
        itemBuilder: (context, index) {
          final LegacyChapter chapter = portal0Chapters[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ChapterDetailScreen(chapter: chapter),
              ));
            },
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: RadialGradient(
                  colors: [
                    Colors.deepPurple.shade700.withOpacity(0.8),
                    Colors.black,
                  ],
                  center: Alignment.topLeft,
                  radius: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurpleAccent.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.teal,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        chapter.teaser,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "✨ Tap to enter ritual →",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}