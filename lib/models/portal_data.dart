import 'chapter.dart';

class PortalData {
  final String id;
  final String title;
  final String description;
  final String theme;
  final String guardianQuote;
  final bool isUnlocked;
  final bool isCompleted;
  final List<Chapter> sessions;

  PortalData({
    required this.id,
    required this.title,
    required this.description,
    required this.theme,
    required this.guardianQuote,
    required this.isUnlocked,
    required this.isCompleted,
    required this.sessions,
  });

  factory PortalData.fromJson(Map<String, dynamic> json) {
    final portalId = json['id'] ?? 'unknown_portal';

    return PortalData(
      id: portalId,
      title: json['title'],
      description: json['description'],
      theme: json['theme'] ?? '',
      guardianQuote: json['guardianQuote'] ?? '',
      isUnlocked: json['isUnlocked'] ?? true,
      isCompleted: json['isCompleted'] ?? false,
      sessions: (json['sessions'] as List)
          .map((sessionJson) {
        final originalId = sessionJson['id'];
        sessionJson['id'] = '${portalId}_session_${originalId.replaceAll('.', '_')}';
        return Chapter.fromJson(sessionJson);
      })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'theme': theme,
      'guardianQuote': guardianQuote,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
  }
}