import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:portal8/screens/login_screen.dart'; // For logout navigation
import 'package:portal8/screens/portal0_screen.dart'; // Your main portal 0 screen
import 'package:portal8/screens/dashboard_screen.dart'; // Dashboard for all portals
import 'package:portal8/screens/referral_screen.dart'; // Import ReferralScreen
import 'package:portal8/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:portal8/screens/settings_screen.dart'; // Import the functional SettingsScreen
import 'package:portal8/utils/starfield_background.dart'; // Import StarfieldBackground
import 'package:portal8/utils/app_constants.dart'; // Import app constants for styling
import 'package:portal8/providers/portal_progress_provider.dart'; // Import progress provider
import 'package:portal8/models/illusion_model.dart'; // Import Illusion model
import 'dart:ui'; // Required for BackdropFilter (glassmorphism)

// Placeholder screens for bottom navigation (now content-only, no Scaffold/AppBar)
class MyJourneyScreen extends StatelessWidget {
  const MyJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Text(
        'My Journey',
        style: kHeadingTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Define the list of screens
  late final List<Widget> _widgetOptions = <Widget>[
    const Portal0Screen(),
    const DashboardScreen(),
    const MyJourneyScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Determine which screen is currently displayed based on _selectedIndex
    final Widget currentScreen = _widgetOptions.elementAt(_selectedIndex);

    return Scaffold(
      extendBody: true, // Allows the body to extend behind the bottom nav bar
      body: Stack(
        children: [
          // The animated starfield background
          const StarfieldBackground(),

          // The current screen content
          IndexedStack(
            index: _selectedIndex,
            children: const [
              Portal0Screen(), // Portal 0 (index 0)
              DashboardScreen(), // Dashboard (index 1)
              MyJourneyScreen(), // Placeholder for My Journey (index 2)
              ProfileScreen(), // NEW: Profile Screen (index 3)
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.donut_large_rounded), // Changed icon for Portal 0
            label: 'Portal 0',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded), // Icon for Dashboard
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_rounded),
            label: 'My Journey',
          ),
          BottomNavigationBarItem( // NEW: Combined Profile Bottom Nav Item
            icon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kCosmicCyan, // Use kCosmicCyan
        unselectedItemColor: Colors.white54,
        backgroundColor: kDeepSpacePurple.withOpacity(0.8), // Use kDeepSpacePurple
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: kSubtitleTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12), // Use kSubtitleTextStyle
        unselectedLabelStyle: kSubtitleTextStyle.copyWith(fontSize: 10), // Use kSubtitleTextStyle
      ),
    );
  }
}

// You can now create a separate ProfileScreen.dart file and import it here
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Example of a reusable menu item widget for the profile screen
  Widget _buildProfileMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: kBodyTextStyle),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 120),
          const CircleAvatar(
            radius: 50,
            backgroundColor: kCosmicCyan,
            child: Icon(Icons.person, size: 60, color: kDeepSpacePurple),
          ),
          const SizedBox(height: 10),
          Text(
            'Cosmic Explorer',
            style: kHeadingTextStyle.copyWith(color: Colors.white),
          ),
          Text(
            'explorer@galaxy.com',
            style: kBodyTextStyle.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 30),
          _buildProfileMenuItem(context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              // Navigate to the SettingsScreen
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
          const Divider(color: Colors.white24, indent: 20, endIndent: 20),
          _buildProfileMenuItem(context,
            icon: Icons.people_alt_rounded,
            title: 'Refer a Friend',
            onTap: () {
              // Navigate to the ReferralScreen
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferralScreen()));
            },
          ),
          const Divider(color: Colors.white24, indent: 20, endIndent: 20),
          _buildProfileMenuItem(context,
            icon: Icons.logout_rounded,
            title: 'Logout',
            onTap: () async {
              // Log out the user and navigate to the login screen
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
