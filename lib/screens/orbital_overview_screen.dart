import 'dart:math';
import 'package:flutter/material.dart';
import '../models/session_data.dart';
import '../widgets/session_orb.dart';
import '../data/session_data_list.dart';

class OrbitalOverviewScreen extends StatelessWidget {
  final String portalName;

  const OrbitalOverviewScreen({required this.portalName});

  @override
  Widget build(BuildContext context) {
    final List<SessionData> sessions = getSessionsForPortal(portalName);

    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        maxScale: 2.5,
        minScale: 0.8,
        child: Stack(
          children: List.generate(sessions.length, (index) {
            final angle = index * (2 * pi / sessions.length);
            final radius = 150.0 + (index * 10); // Spiral effect
            final offset = Offset(
              radius * cos(angle) + MediaQuery.of(context).size.width / 2 - 30,
              radius * sin(angle) + MediaQuery.of(context).size.height / 2 - 30,
            );
            return Positioned(
              left: offset.dx,
              top: offset.dy,
              child: SessionOrb(session: sessions[index]),
            );
          }),
        ),
      ),
    );
  }
}