import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String paymentId;
  final bool isBundle;
  final int portalIndex;

  const PaymentSuccessScreen({
    Key? key,
    required this.paymentId,
    required this.isBundle,
    required this.portalIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = isBundle
        ? '🌌 Cosmic Bundle Unlocked!'
        : '🔓 Portal $portalIndex Unlocked!';
    final subtitle = 'Payment ID: $paymentId';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Success'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.purpleAccent,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(subtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}