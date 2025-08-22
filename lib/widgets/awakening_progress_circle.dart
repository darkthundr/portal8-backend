// lib/widgets/awakening_progress_circle.dart

import 'package:flutter/material.dart';

class AwakeningProgressCircle extends StatelessWidget {
  final int unlockedSessions;
  final int totalSessions;

  const AwakeningProgressCircle({
    super.key,
    required this.unlockedSessions,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final progress = ((unlockedSessions - 1) / totalSessions).clamp(0.0, 1.0);
    final progressPercentage = (progress * 100).toInt();

    return SizedBox(
      width: screenSize.width * 0.4,
      height: screenSize.width * 0.4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: screenSize.width * 0.35,
            height: screenSize.width * 0.35,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(theme.colorScheme.primary, theme.colorScheme.secondary, progress)!,
              ),
              strokeWidth: 8.0,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your Awakening:",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontFamily: 'Orbitron',
                ),
              ),
              Text(
                "$progressPercentage%",
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}