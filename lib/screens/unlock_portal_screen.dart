import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Import theme and state management
import 'package:portal8/utils/app_theme.dart';
import 'package:portal8/providers/portal_progress_provider.dart';

// UnlockPortalScreen: Guides the user to complete a task to unlock the next portal.
class UnlockPortalScreen extends StatelessWidget {
  const UnlockPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider to update the state
    final portalProgress = Provider.of<PortalProgressProvider>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: kCosmicBackgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () => context.go('/dashboard'),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.arrow_back_ios, color: kNebulaWhite),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Unlock the Next Portal',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                'To open this portal, you must first complete your current sessions and raise your consciousness.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: kNebulaWhite.withOpacity(0.7)),
              ),
              const Spacer(),
              _buildProgressCard(context, portalProgress),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Simulate unlocking the next portal.
                  // In a real app, this would be tied to a task completion event.
                  portalProgress.unlockNextPortal();
                  context.go('/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentNeonGreen,
                  foregroundColor: kCosmicBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'Complete Current Path',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, PortalProgressProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kStarlightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kStarlightBlue.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Progress',
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          // Using Consumer to listen to changes in progress
          Consumer<PortalProgressProvider>(
            builder: (context, provider, child) {
              return Text(
                'You have completed ${ (provider.progress * 100).toInt() }% of your journey.',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep going to unlock the next level of consciousness.',
            style: TextStyle(color: kNebulaWhite, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
