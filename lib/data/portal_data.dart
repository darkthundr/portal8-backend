import 'package:flutter/material.dart';
import '../data/repositories/portal_repository.dart';
import '../models/portal_data.dart';
import '../screens/chapter_screen.dart';

class PortalScreen extends StatefulWidget {
  final String portalId;

  const PortalScreen({required this.portalId, super.key});

  @override
  State<PortalScreen> createState() => _PortalScreenState();
}

class _PortalScreenState extends State<PortalScreen> {
  final PortalRepository repository = PortalRepository();
  PortalData? portal;

  @override
  void initState() {
    super.initState();
    loadPortal();
  }

  Future<void> loadPortal() async {
    final loadedPortal = await repository.loadPortal(widget.portalId);
    setState(() {
      portal = loadedPortal;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (portal == null) {
      return Scaffold(
        appBar: AppBar(title: Text("🌀 ${widget.portalId}")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(portal!.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: portal!.sessions.length,
              itemBuilder: (context, index) {
                final chapter = portal!.sessions[index];
                return Card(
                  color: Colors.deepPurple.shade700,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    title: Text(chapter.title, style: const TextStyle(color: Colors.white, fontSize: 18)),
                    subtitle: Text(chapter.teaser, style: const TextStyle(color: Colors.white70)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ChapterScreen(chapter: chapter),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Theme: ${portal!.theme}", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text("“${portal!.guardianQuote}”", style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
          const Divider(color: Colors.white24, thickness: 1),
        ],
      ),
    );
  }
}