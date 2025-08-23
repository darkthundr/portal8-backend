import 'package:flutter/material.dart';
import '../screens/purchase_screen.dart';

class LockedPortalCard extends StatelessWidget {
  final String portalId;
  final String title;
  final String subtitle;
  final String imageAsset;

  const LockedPortalCard({
    super.key,
    required this.portalId,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🔮 Background Image
        Container(
          height: 220,
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
          ),
        ),

        // 🧊 Lock Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  glowingPurchaseButton(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget glowingPurchaseButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const PurchaseScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          "🔒 Unlock Portal",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}