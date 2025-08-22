class Illusion {
  final int id;
  final int portalId;
  final String title;
  final String description;
  final String imagePath;

  const Illusion({
    required this.id,
    required this.portalId,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  // A static list of all illusions, acting as a simple database
  static const List<Illusion> allIllusions = [
    // Dashboard Portals
    Illusion(id: 0, portalId: 0, title: 'Portal 0', description: 'The First Step', imagePath: 'assets/images/portal0_icon.png'),
    Illusion(id: 1, portalId: 1, title: 'Portal 1', description: 'The Illusion of Self', imagePath: 'assets/images/portal1_icon.png'),
    Illusion(id: 2, portalId: 2, title: 'Portal 2', description: 'The Illusion of Time', imagePath: 'assets/images/portal2_icon.png'),
    // You would add more portals here...

    // Portal 0 Sessions
    Illusion(id: 1, portalId: 0, title: 'Session 1: The First Step', description: 'Begin your journey by confronting the most basic illusion.', imagePath: 'assets/images/session1.png'),
    Illusion(id: 2, portalId: 0, title: 'Session 2: The Echo Chamber', description: 'Learn to distinguish your own voice from the noise of others.', imagePath: 'assets/images/session2.png'),
    // You would add more sessions here...
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

