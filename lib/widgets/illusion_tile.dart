import 'package:flutter/material.dart';

class IllusionTile extends StatelessWidget {
  final int portalNumber;
  final String title;
  final String subtitle;
  final int price;

  const IllusionTile({
    super.key,
    required this.portalNumber,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: price == 0
          ? const Text("Free", style: TextStyle(color: Colors.green))
          : Text("₹$price", style: const TextStyle(color: Colors.amber)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $title...")),
        );
      },
    );
  }
}
