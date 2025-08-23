import 'package:flutter/material.dart';

class MyJourneyScreen extends StatefulWidget {
  const MyJourneyScreen({super.key});

  @override
  State<MyJourneyScreen> createState() => _MyJourneyScreenState();
}

class _MyJourneyScreenState extends State<MyJourneyScreen> {
  String selectedState = '';
  final List<String> mentalStates = [
    'Overthinking',
    'Emotional Pain',
    'Loneliness',
    'Fear of Future',
    'Ego Cracks',
    'Seeking Love',
  ];

  String getIllusionFromState(String state) {
    switch (state) {
      case 'Overthinking':
        return 'Illusion of Control';
      case 'Emotional Pain':
        return 'Illusion of Separation';
      case 'Loneliness':
        return 'Illusion of Isolation';
      case 'Fear of Future':
        return 'Illusion of Time';
      case 'Ego Cracks':
        return 'Illusion of Identity';
      case 'Seeking Love':
        return 'Illusion of Lack';
      default:
        return 'Unknown Illusion';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journey'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How are you feeling right now?',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: mentalStates.map((state) {
                final bool isSelected = selectedState == state;
                return ChoiceChip(
                  label: Text(state),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => selectedState = state);
                  },
                  backgroundColor: Colors.grey.shade800,
                  selectedColor: Colors.amberAccent,
                  labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            if (selectedState.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'You are currently stuck in:',
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    getIllusionFromState(selectedState),
                    style: const TextStyle(fontSize: 22, color: Colors.amberAccent, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Map to Awakening:',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B1446), Color(0xFF0D0B1F)],
                      ),
                      border: Border.all(color: Colors.amber.withOpacity(0.4)),
                    ),
                    child: const Center(
                      child: Text(
                        '✨ Your orb is heading toward the Infinite ✨\n(Visual map coming soon)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white60),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}