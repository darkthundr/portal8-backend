class LegacyChapter {
  final String id;
  final String title;
  final String teaser;
  final String content;
  final List<String> rituals;
  final String emotionalCheckpoint;
  final String communityPrompt;
  final String closingWhisper;

  LegacyChapter({
    required this.id,
    required this.title,
    required this.teaser,
    required this.content,
    required this.rituals,
    required this.emotionalCheckpoint,
    required this.communityPrompt,
    required this.closingWhisper,
  });

  factory LegacyChapter.fromJson(Map<String, dynamic> json) {
    return LegacyChapter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      teaser: json['teaser'] ?? '',
      content: json['content'] ?? '',
      rituals: List<String>.from(json['rituals'] ?? []),
      emotionalCheckpoint: json['emotionalCheckpoint'] ?? '',
      communityPrompt: json['communityPrompt'] ?? '',
      closingWhisper: json['closingWhisper'] ?? '',
    );
  }
}