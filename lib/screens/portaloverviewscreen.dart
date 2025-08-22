import 'package:flutter/material.dart';

class PortalOverviewScreen extends StatelessWidget {
  final int portalIndex;
  const PortalOverviewScreen({super.key, required this.portalIndex});

  @override
  Widget build(BuildContext context) {
    final sessions = List.generate(8, (i) => "Session ${i + 1}: Subtitle ${portalIndex}.${i + 1}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Portal $portalIndex Overview"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.check_circle_outline, color: Colors.white),
            title: Text(
              sessions[index],
              style: const TextStyle(color: Colors.white),
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text("Continue"),
            ),
          );
        },
      ),
    );
  }
}