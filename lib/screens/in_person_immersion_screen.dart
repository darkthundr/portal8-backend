import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InPersonImmersionScreen extends StatelessWidget {
  const InPersonImmersionScreen({super.key});

  // 📞 Call
  void _launchCall() async {
    final Uri url = Uri(scheme: 'tel', path: '+919876543210'); // replace with real number
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // 💬 WhatsApp
  void _launchWhatsApp() async {
    final Uri url = Uri.parse("https://wa.me/919876543210"); // replace with real number
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // 📝 Google Form
  void _launchForm() async {
    final Uri url = Uri.parse("https://forms.gle/your-form-link"); // replace with real form link
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("🌌 In-Person Cosmic Immersion"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "✨ Step beyond the digital.\n\nJoin us for a 3 or 7 day In-Person Cosmic Immersion — a sacred experience of dissolving illusions, syncing with atomic vibrations, and awakening to vast infinite space.",
              style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Fill Form
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _launchForm,
              child: const Text("📝 Fill Interest Form", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),

            // Call Us
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _launchCall,
              child: const Text("📞 Call Us", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),

            // WhatsApp
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _launchWhatsApp,
              child: const Text("💬 WhatsApp Us", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
