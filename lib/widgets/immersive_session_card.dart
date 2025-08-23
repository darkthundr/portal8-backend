import 'package:flutter/material.dart';

// Import color constants from your theme file
import 'package:portal8/utils/app_theme.dart';

// Custom widget for the long, immersive session cards
class ImmersiveSessionCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const ImmersiveSessionCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Height and margin to create a distinct, immersive card feel
      height: 250,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: kCosmicBlack,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: kStarlightBlue.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: kStarlightBlue.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          )
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder for a flowing cosmic background animation
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: const ColoredBox(color: Colors.transparent),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: kNebulaWhite,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: kStarlightBlue),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            top: 24,
            child: Icon(
              Icons.play_circle_outline,
              color: kAccentNeonGreen,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
