import 'package:flutter/material.dart';

class RitualPreviewModal extends StatelessWidget {
  final String portalName;
  final String theme;
  final List<String> sessions;
  final int completed;

  const RitualPreviewModal({
    super.key,
    required this.portalName,
    required this.theme,
    required this.sessions,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(portalName, style: const TextStyle(fontSize: 24, color: Colors.tealAccent)),
            const SizedBox(height: 4),
            Text(theme, style: const TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 16),
            ...sessions.asMap().entries.map((entry) {
              final i = entry.key;
              final title = entry.value;
              final done = i < completed;

              return ListTile(
                leading: Icon(done ? Icons.check_circle : Icons.circle_outlined,
                    color: done ? Colors.tealAccent : Colors.white30),
                title: Text(title, style: const TextStyle(color: Colors.white)),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                print("Begin ritual for $portalName");
              },
              child: const Text("Begin Ritual"),
            ),
          ],
        ),
      ),
    );
  }
}