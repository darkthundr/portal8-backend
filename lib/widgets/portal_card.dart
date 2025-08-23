import 'package:flutter/material.dart';

class PortalCard extends StatelessWidget {
  final int portalNumber;
  final int price;
  final bool isUnlocked;
  final bool isIndia;
  final VoidCallback onTap;

  const PortalCard({
    Key? key,
    required this.portalNumber,
    required this.price,
    required this.isUnlocked,
    required this.isIndia,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayPrice = isUnlocked ? 'Unlocked' : '${isIndia ? "₹" : "\$"}$price';
    final priceColor = isUnlocked ? Colors.greenAccent : Colors.white70;
    final currencyLabel = isIndia ? '🇮🇳 INR' : '🌎 USD';

    return GestureDetector(
      onTap: isUnlocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.deepPurpleAccent : Colors.purple[800],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Portal $portalNumber',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayPrice,
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 16,
                  ),
                ),
                if (isUnlocked)
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 18),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (!isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 6),
            Text(
              currencyLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
