import 'package:flutter/foundation.dart';
import 'package:portal8/models/session_model.dart';
import 'package:portal8/models/illusion_model.dart';

class PortalProgressProvider with ChangeNotifier {
  // A set to store the IDs of all completed sessions.
  final Set<int> _completedSessionIds = {};

  // Method to check if a single session has been completed.
  bool isSessionCompleted(int sessionId) => _completedSessionIds.contains(sessionId);

  // Checks if a portal is completed by checking if all its sessions are completed.
  bool isPortalCompleted(int portalId) {
    // This is a simplified check. We check if the last session of the previous portal is completed.
    final lastSessionOfPreviousPortalId = Session.getSessionsForPortal(portalId - 1).lastOrNull?.id;
    if (portalId == 0) return true;
    if (lastSessionOfPreviousPortalId == null) return false;
    return isSessionCompleted(lastSessionOfPreviousPortalId);
  }

  Future<void> markSessionComplete(int portalId, int sessionId) async {
    if (!_completedSessionIds.contains(sessionId)) {
      _completedSessionIds.add(sessionId);
      notifyListeners();
    }
  }

  // Method to get the progress of a specific portal.
  double getPortalProgress(int portalId, List<Session> allSessions) {
    final portalSessions = allSessions.where((session) => session.portalId == portalId).toList();
    if (portalSessions.isEmpty) return 0.0;

    final completedCount = portalSessions.where((session) => isSessionCompleted(session.id)).length;
    return completedCount / portalSessions.length;
  }

  // Method to get the number of unlocked sessions for a portal.
  int getUnlockedSessionCount(int portalId) {
    final sessionsInPortal = Session.getSessionsForPortal(portalId);
    final completedCount = sessionsInPortal.where((s) => isSessionCompleted(s.id)).length;

    if (completedCount == sessionsInPortal.length) {
      return sessionsInPortal.length;
    }
    return completedCount + 1;
  }
}
