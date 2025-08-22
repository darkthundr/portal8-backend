import 'package:flutter/material.dart';

class PortalUnlockScreen extends StatelessWidget {
  final String portalName;

  const PortalUnlockScreen({Key? key, required this.portalName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade900,
        title: Text(portalName, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          "Welcome to $portalName\n\n(Portal content coming soon...)",
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
