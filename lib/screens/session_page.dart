import 'package:flutter/material.dart';

class SessionPage extends StatelessWidget {
  final Map<String, dynamic> session;
  final int index;
  final int total;

  const SessionPage({required this.session, required this.index, required this.total, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("Session $index of $total", style: TextStyle(color: Colors.deepPurpleAccent)),
          const SizedBox(height: 12),
          Text(session['title'] ?? 'Untitled',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 24),
          ExpandableSection(label: "Hook", content: session['hook']),
          ExpandableSection(label: "Story", content: session['story']),
          ExpandableSection(label: "Guided Practice", content: session['guidedPractice']),
          ExpandableSection(label: "Reflection", content: session['reflection']),
          ExpandableSection(label: "Micro Practice", content: session['microPractice']),
          ExpandableSection(label: "Scientific Note", content: session['scientificNote']),
          ExpandableSection(label: "Cosmic Analogy", content: session['cosmicAnalogy']),
        ],
      ),
    );
  }
}