import 'package:flutter/material.dart';

class CosmicMapScreen extends StatelessWidget {
  const CosmicMapScreen({super.key});

  final List<Map<String, dynamic>> portals = const [
    {'title': 'Breakup', 'unlocked': true},
    {'title': 'Overthinking', 'unlocked': true},
    {'title': 'Fear of Future', 'unlocked': false},
    {'title': 'Self Doubt', 'unlocked': false},
    {'title': 'Ego Death', 'unlocked': false},
    {'title': 'Divine Love', 'unlocked': false},
    {'title': 'You Are Universe', 'unlocked': false},
    {'title': 'No Mind No Self', 'unlocked': false},
    {'title': 'Cosmic Realization', 'unlocked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Awakening Map'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.deepPurple[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: portals.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final portal = portals[index];
            return GestureDetector(
              onTap: portal['unlocked']
                  ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${portal['title']} is opening...')),
                );
              }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: portal['unlocked'] ? Colors.purpleAccent : Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: portal['unlocked'] ? Colors.white : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    portal['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: portal['unlocked'] ? Colors.white : Colors.grey[400],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
