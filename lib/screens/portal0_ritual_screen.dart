import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
//import '../data/portal0_sessions.dart';

class Portal0RitualScreen extends StatelessWidget {
  const Portal0RitualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Portal 0 – The First Crack"),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: portal0Sessions.length,
        itemBuilder: (context, index) {
          final session = portal0Sessions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade700, Colors.indigo.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  session.subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "🔹 Practice:\n${session.practice}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "💓 Emotional Checkpoint:\n${session.emotionalCheckpoint}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.pinkAccent,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "🌐 Community Prompt:\n${session.communityPrompt}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.lightBlueAccent,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "🌀 Closing Whisper:\n${session.closingWhisper}",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.tealAccent,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}