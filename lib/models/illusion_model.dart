import 'dart:ui'; // Add this line for ImageFilter

class Illusion {
  // Add const to the constructor
  const Illusion({
    required this.id,
    required this.portalId,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final int id;
  final int portalId;
  final String title;
  final String description;
  final String imagePath;

  // A static list of all illusions, acting as a simple database
  static const List<Illusion> allIllusions = [
    // Dashboard Portals
    Illusion(id: 0, portalId: 0, title: 'Portal 0', description: 'The First Step', imagePath: 'assets/images/portal0_icon.png'),
    Illusion(id: 1, portalId: 1, title: 'Portal 1', description: 'The Illusion of Self', imagePath: 'assets/images/portal1_icon.png'),
    Illusion(id: 2, portalId: 2, title: 'Portal 2', description: 'The Illusion of Time', imagePath: 'assets/images/portal2_icon.png'),
    Illusion(id: 3, portalId: 3, title: 'Portal 3', description: 'The Illusion of Control', imagePath: 'assets/images/portal3_icon.png'),
    Illusion(id: 4, portalId: 4, title: 'Portal 4', description: 'The Illusion of Fear', imagePath: 'assets/images/portal4_icon.png'),
    Illusion(id: 5, portalId: 5, title: 'Portal 5', description: 'The Illusion of Judgment', imagePath: 'assets/images/portal5_icon.png'),
    Illusion(id: 6, portalId: 6, title: 'Portal 6', description: 'The Illusion of Separation', imagePath: 'assets/images/portal6_icon.png'),
    Illusion(id: 7, portalId: 7, title: 'Portal 7', description: 'The Illusion of Reality', imagePath: 'assets/images/portal7_icon.png'),
    Illusion(id: 8, portalId: 8, title: 'Portal 8', description: 'The Final Illusion', imagePath: 'assets/images/portal8_icon.png'),
  ];

  // A static method to find an illusion by its ID
  static Illusion? getById(int id) {
    try {
      return allIllusions.firstWhere((illusion) => illusion.id == id);
    } catch (e) {
      return null;
    }
  }
}
