import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortalUnlockScreen extends StatelessWidget {
  final String portalName;
  const PortalUnlockScreen({super.key, required this.portalName});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sessions = [
      {'title': 'Session 1: Breath & Calm', 'desc': 'Feel the shift in 3 minutes.'},
      {'title': 'Session 2: Cosmic Body Awareness', 'desc': 'You are made of stars.'},
      {'title': 'Session 3: Real vs Illusion', 'desc': 'Dissolve boundaries.'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0E0B1F),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(portalName, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            '✨ Welcome to $portalName',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'These sessions will help you dissolve illusions and reconnect with your true cosmic nature.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ...sessions.map((session) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Material(
              color: const Color(0xFF1F1B3A),
              borderRadius: BorderRadius.circular(16),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session['title']!,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session['desc']!,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
