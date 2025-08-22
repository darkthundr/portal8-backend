import 'package:flutter/material.dart';

class PortalsHomeScreen extends StatelessWidget {
  const PortalsHomeScreen({super.key});

  final List<PortalInfo> portals = const [
    PortalInfo(
      name: "Portal0",
      title: "The Breath of Longing",
      description: "Begin your awakening journey",
      route: "/portal0",
      gradient: [Colors.deepPurple, Colors.black],
      icon: Icons.self_improvement,
    ),
    PortalInfo(
      name: "Portal1",
      title: "The Flame of Truth",
      description: "Enter the fire of clarity",
      route: "/portal1", // 🔜 Future route
      gradient: [Colors.orange, Colors.deepOrange],
      icon: Icons.local_fire_department,
    ),
    // Add more portals here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: portals.length,
          itemBuilder: (context, index) {
            final portal = portals[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, portal.route);
              },
              child: PortalCard(portal: portal),
            );
          },
        ),
      ),
    );
  }
}

class PortalInfo {
  final String name;
  final String title;
  final String description;
  final String route;
  final List<Color> gradient;
  final IconData icon;

  const PortalInfo({
    required this.name,
    required this.title,
    required this.description,
    required this.route,
    required this.gradient,
    required this.icon,
  });
}

class PortalCard extends StatelessWidget {
  final PortalInfo portal;

  const PortalCard({required this.portal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: portal.gradient),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: portal.gradient.first.withOpacity(0.6),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(portal.icon, size: 40, color: Colors.white),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(portal.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                const SizedBox(height: 8),
                Text(portal.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}