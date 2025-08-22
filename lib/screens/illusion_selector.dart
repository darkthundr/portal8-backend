import 'package:flutter/material.dart';
import '../data/portal_data.dart';

class IllusionSelector extends StatelessWidget {
  const IllusionSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: portals.length, // ✅ use 'portals' not 'portalList'
      itemBuilder: (context, index) {
        final portal = portals[index];
        return ListTile(
          title: Text(portal.title),
          subtitle: Text(portal.subtitle),
          trailing: portal.price == 0
              ? const Text("Free", style: TextStyle(color: Colors.green))
              : Text("₹${portal.price}",
              style: const TextStyle(color: Colors.amber)),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Selected ${portal.title}")),
            );
          },
        );
      },
    );
  }
}
