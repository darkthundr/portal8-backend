import 'package:flutter/material.dart';
import '../models/session_data.dart';

class SessionOrb extends StatelessWidget {
  final SessionData session;

  const SessionOrb({required this.session});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement ritual modal
        print("Tapped: ${session.title}");
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: session.isCompleted
                ? [Colors.purpleAccent, Colors.deepPurple]
                : [Colors.blueGrey, Colors.black],
          ),
          boxShadow: [
            BoxShadow(
              color: session.isCompleted ? Colors.purpleAccent : Colors.white24,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(session.icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}