import 'package:flutter/foundation.dart';

@immutable
class Session {
  final int id;
  final int portalId;
  final int sessionNumber;
  final String title;
  final String description;

  const Session({
    required this.id,
    required this.portalId,
    required this.sessionNumber,
    required this.title,
    required this.description,
  });

  // A hardcoded list of sessions for demonstration purposes.
  static final List<Session> _allSessions = [
    // Portal 0 Sessions
    const Session(id: 1, portalId: 0, sessionNumber: 1, title: 'Session 1: The First Step', description: 'Begin your journey into the unknown.'),
    const Session(id: 2, portalId: 0, sessionNumber: 2, title: 'Session 2: Unlocking the Mind', description: 'Learn to quiet the noise and focus.'),
    const Session(id: 3, portalId: 0, sessionNumber: 3, title: 'Session 3: Glimpse of the Void', description: 'Experience the stillness between thoughts.'),
    const Session(id: 4, portalId: 0, sessionNumber: 4, title: 'Session 4: The Great Unraveling', description: 'Start to question your own assumptions.'),
    // Portal 1 Sessions
    const Session(id: 5, portalId: 1, sessionNumber: 1, title: 'Session 5: The Illusion of Self', description: 'Who are you really?'),
    const Session(id: 6, portalId: 1, sessionNumber: 2, title: 'Session 6: Breaking the Mirror', description: 'Challenge your self-perception.'),
    // Add more sessions for other portals as needed...
  ];

  static Session? getById(int id) {
    return _allSessions.firstWhere((session) => session.id == id);
  }

  static List<Session> getSessionsForPortal(int portalId) {
    return _allSessions.where((session) => session.portalId == portalId).toList();
  }
}
