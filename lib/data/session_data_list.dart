import '../models/session_data.dart';
import 'package:flutter/material.dart';

List<SessionData> getSessionsForPortal(String portalName) {
  return [
    SessionData(title: "Awakening Breath", icon: Icons.self_improvement, portalName: "Portal0"),
    SessionData(title: "Temple of Longing", icon: Icons.star, portalName: "Portal0"),
    SessionData(title: "Mystic Mirror", icon: Icons.visibility, portalName: "Portal0"),
    SessionData(title: "Craving Compass", icon: Icons.explore, portalName: "Portal0"),
    SessionData(title: "Portal of Silence", icon: Icons.nightlight, portalName: "Portal0"),
    // Add more sessions as needed
  ].where((s) => s.portalName == portalName).toList();
}