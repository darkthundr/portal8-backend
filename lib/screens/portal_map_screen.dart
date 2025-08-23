import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PortalsMapScreen extends StatelessWidget {
  const PortalsMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'You have 8 Portals to pass to exit the Matrix',
                style: GoogleFonts.orbitron(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 8,
                itemBuilder: (context, index) {
                  final isUnlocked = index == 0;
                  final isCompleted = index == 0; // Only Portal 0 completed

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade900,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blueAccent.shade200, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.check_circle
                              : isUnlocked
                              ? Icons.lock_open
                              : Icons.lock,
                          color: isCompleted
                              ? Colors.greenAccent
                              : isUnlocked
                              ? Colors.amber
                              : Colors.grey,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Portal ${index + 1}',
                          style: GoogleFonts.orbitron(
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isUnlocked ? Colors.white : Colors.grey.shade500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (isUnlocked)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              // TODO: Navigate to portal content
                            },
                            child: const Text('Enter'),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Future Drops',
                    style: GoogleFonts.orbitron(
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade900,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.deepPurpleAccent, width: 1),
                    ),
                    child: Text(
                      'Coming soon... Bonus Cosmic Realms, New Portal Expansions, Gamified Awakening Tools 🔮',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: Trigger buy bundle screen
                      },
                      child: Text(
                        'Buy Full Cosmic Bundle',
                        style: GoogleFonts.orbitron(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
