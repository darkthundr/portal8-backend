// lib/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.onPrimary.withOpacity(0.9),
            theme.colorScheme.primary.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close_rounded, color: theme.colorScheme.secondary, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground.withOpacity(0.9),
                shadows: [
                  Shadow(
                    color: theme.colorScheme.secondary,
                    blurRadius: 10.0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48), // Spacer for symmetry
        ],
      ),
    );
  }
}