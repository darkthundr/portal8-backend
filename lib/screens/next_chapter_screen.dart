import 'package:flutter/material.dart';

class NextChapterScreen extends StatelessWidget {
  const NextChapterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "🚀 Welcome to the Next Portal",
          style: TextStyle(fontSize: 24, color: Colors.tealAccent),
        ),
      ),
    );
  }
}// TODO Implement this library.