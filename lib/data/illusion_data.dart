import 'package:flutter/material.dart';

class Illusion {
  final String id;
  final String title;
  final String description;

  const Illusion({
    required this.id,
    required this.title,
    required this.description,
  });

  // This is the static list that the MyJourneyScreen uses.
  // It must contain Illusion objects for the timeline to appear.
  static const List<Illusion> illusions = [
    Illusion(
      id: 'portal-0',
      title: 'Portal 0: The First Crack',
      description: 'Begin your cosmic journey by cracking the first illusion. This portal introduces you to the core concepts of the universe.',
    ),
    Illusion(
      id: 'portal-1',
      title: 'Portal 1: The Echoing Void',
      description: 'Explore the vast emptiness between stars and learn about the nature of silence and space.',
    ),
    Illusion(
      id: 'portal-2',
      title: 'Portal 2: The Quantum Loom',
      description: 'Weave through the fabric of reality and discover the interconnectedness of all things at a quantum level.',
    ),
    Illusion(
      id: 'portal-3',
      title: 'Portal 3: The Astral Projection',
      description: 'Learn to navigate the astral plane and perceive truths beyond physical limitations.',
    ),
    Illusion(
      id: 'portal-4',
      title: 'Portal 4: The Crystalline Mind',
      description: 'Cleanse and clarify your inner world to achieve a state of perfect mental clarity.',
    ),
    // You can add more Illusion objects here
  ];

  // A helper method to get an illusion by its ID
  static Illusion? getById(String id) {
    try {
      return illusions.firstWhere((illusion) => illusion.id == id);
    } catch (e) {
      return null;
    }
  }
}
