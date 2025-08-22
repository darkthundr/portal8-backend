import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SessionPagerScreen extends StatefulWidget {
  final String portalId;

  const SessionPagerScreen({required this.portalId, Key? key}) : super(key: key);

  @override
  State<SessionPagerScreen> createState() => _SessionPagerScreenState();
}

class _SessionPagerScreenState extends State<SessionPagerScreen> {
  List<dynamic> sessions = [];

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final path = 'assets/portals/${widget.portalId}.json';
    final data = await rootBundle.loadString(path);
    final decoded = json.decode(data);
    setState(() {
      sessions = decoded['sessions'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: sessions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return SessionPage(session: session, index: index + 1, total: sessions.length);
        },
      ),
    );
  }
}