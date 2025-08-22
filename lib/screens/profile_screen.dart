import 'package:flutter/material.dart';
import 'package:portal8/utils/app_constants.dart';
import 'package:portal8/utils/starfield_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StarfieldBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Profile Picture Placeholder
              CircleAvatar(
                radius: 60,
                backgroundColor: kStarlightBlue,
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: kStarlightBlue.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Explorer 42',
                style: kHeadingTextStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'You are currently exploring Portal 0',
                style: kBodyTextStyle.copyWith(color: kNebulaWhite.withOpacity(0.7)),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: const [
                    ProfileTile(
                      icon: Icons.track_changes_rounded,
                      title: 'My Journey',
                    ),
                    ProfileTile(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Refer a Friend',
                    ),
                    ProfileTile(
                      icon: Icons.settings_rounded,
                      title: 'Settings',
                    ),
                    ProfileTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton(
                  onPressed: () {
                    // This button should be handled by main_app_shell.dart logout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPortalPurple,
                    foregroundColor: kNebulaWhite,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text('Logout', style: kButtonTextStyle.copyWith(color: kNebulaWhite)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: kStarlightBlue),
      title: Text(title, style: kSubtitleTextStyle),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kStarlightSilver),
      onTap: () {
        // Handle navigation for each tile
      },
    );
  }
}
