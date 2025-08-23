class Chapter {
  final int portalId;
  final String title;
  final String teaser;
  final String content;
  final List<String> microPractices;

  Chapter({
    required this.portalId,
    required this.title,
    required this.teaser,
    required this.content,
    required this.microPractices,
  });
}

final List<Chapter> allChapters = [
// Portal 0 – THE CRACK
Chapter(
  portalId: 0,
  title: "The Two-Second Surprise",
  teaser: "Feel your finger melt into space.",
  content: """
When you press your finger on your wrist right now — you feel *skin*. But something odd happens if you pause for just 2 seconds more.

You start to feel… softness. Space. A little wobble.

This is the first crack in your illusion.

Atoms are mostly empty space. That means: you are not a 'solid body', you’re mostly dancing emptiness pretending to be solid for a while.

🌀 Practice:
Place your finger gently on your wrist.
Now breathe in for 6 seconds — hold — breathe out for 6.
Do this 3 times.

What you're feeling isn’t just skin — it’s a quiet cosmic movie happening inside you.
""",
  microPractices: [
    "6-second wrist breath (3 rounds)",
    "Notice 'gap' between skin and bone",
  ],
),
];