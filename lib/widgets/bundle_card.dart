import 'package:flutter/material.dart';

class BundleCard extends StatelessWidget {
  final int price;
  final bool isUnlocked;
  final bool isIndia;
  final VoidCallback onTap;
  final bool isLoading;

  const BundleCard({
    Key? key,
    required this.price,
    required this.isUnlocked,
    required this.isIndia,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayPrice = isUnlocked ? 'Unlocked' : '${isIndia ? "₹" : "\$"}$price';
    final priceColor = isUnlocked ? Colors.greenAccent : Colors.white70;
    final regionLabel = isIndia ? '🇮🇳 INR via Razorpay' : '🌎 USD via Razorpay';

    return GestureDetector(
      onTap: isUnlocked || isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.green[700] : Colors.deepPurple[700],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Cosmic Bundle',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayPrice,
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 18,
                  ),
                ),
                if (isUnlocked)
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (!isUnlocked)
              isLoading
                  ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.orangeAccent,
                  ),
                ),
              )
                  : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Buy Bundle',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              regionLabel,
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
