class Chapter {
  final String id;
  final String title;
  final String teaser;
  final String hook;
  final String story;
  final List<String> guidedPractice;
  final String reflection;
  final String microPractice;
  final String scientificNote;
  final String cosmicAnalogy;

  Chapter({
    required this.id,
    required this.title,
    required this.teaser,
    required this.hook,
    required this.story,
    required this.guidedPractice,
    required this.reflection,
    required this.microPractice,
    required this.scientificNote,
    required this.cosmicAnalogy,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      teaser: json['teaser'] ?? '',
      hook: json['hook'] ?? '',
      story: json['story'] ?? '',
      guidedPractice: List<String>.from(json['guidedPractice'] ?? []),
      reflection: json['reflection'] ?? '',
      microPractice: json['microPractice'] ?? '',
      scientificNote: json['scientificNote'] ?? '',
      cosmicAnalogy: json['cosmicAnalogy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'teaser': teaser,
      'hook': hook,
      'story': story,
      'guidedPractice': guidedPractice,
      'reflection': reflection,
      'microPractice': microPractice,
      'scientificNote': scientificNote,
      'cosmicAnalogy': cosmicAnalogy,
    };
  }
}