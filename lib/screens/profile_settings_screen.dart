import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portal8/screens/login_screen.dart';

// --- Data Model ---
class UserProfileData {
  final String name;
  final String email;
  final String joined;
  final List<PaymentRecord> paymentHistory;

  UserProfileData({
    this.name = "Seeker",
    this.email = "",
    this.joined = "",
    this.paymentHistory = const [],
  });
}

class PaymentRecord {
  final DateTime date;
  final int amount;

  PaymentRecord({required this.date, required this.amount});
}

// --- Main Screen ---
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  UserProfileData? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      List<PaymentRecord> paymentHistory = [];
      if (data != null && data['paymentHistory'] != null) {
        final rawPayments = List<Map<String, dynamic>>.from(data['paymentHistory']);
        paymentHistory = rawPayments.map((p) {
          DateTime date = DateTime.now();
          if (p['timestamp'] != null) {
            final ts = p['timestamp'];
            if (ts is Timestamp) {
              date = ts.toDate();
            } else if (ts is Map && ts['_seconds'] != null) {
              date = DateTime.fromMillisecondsSinceEpoch(ts['_seconds'] * 1000);
            }
          }
          return PaymentRecord(
            date: date,
            amount: p['amount'] ?? 0,
          );
        }).toList();
        paymentHistory.sort((a, b) => b.date.compareTo(a.date));
      }

      if (data != null) {
        _userData = UserProfileData(
          name: data['name'] ?? user.displayName ?? "Seeker",
          email: data['email'] ?? user.email ?? "",
          joined: _formatTimestamp(data['joined']),
          paymentHistory: paymentHistory,
        );
      } else {
        _userData = UserProfileData(email: user.email ?? "", paymentHistory: paymentHistory);
      }
    } catch (e) {
      _userData = UserProfileData(email: user.email ?? "", name: "Error Loading");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _formatTimestamp(dynamic ts) {
    if (ts is Timestamp) {
      final date = ts.toDate();
      return "${date.day}/${date.month}/${date.year}";
    }
    return "";
  }

  void _openAboutUs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[900],
        title: const Text("About Portal8", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Portal8 is your gateway to awakening — a cosmic journey through immersive portals designed to reveal your infinite nature.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[900],
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
        content: const SingleChildScrollView(
          child: Text(
            "Your privacy matters. Portal8 does not share your data with third parties. All personal information is securely stored in Firebase and used only to enhance your journey.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  void _openContactUs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueAccent[900],
        title: const Text("Contact Us", style: TextStyle(color: Colors.white)),
        content: const Text(
          "For support or feedback, reach out to us at:\n\nshivaportal8@gmail.com",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
  }

  Widget _buildPaymentHistory() {
    if (_userData == null || _userData!.paymentHistory.isEmpty) {
      return const Text(
        "No payment history found.",
        style: TextStyle(color: Colors.white54, fontSize: 14),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _userData!.paymentHistory.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final payment = _userData!.paymentHistory[index];
          final dateStr = "${payment.date.day}/${payment.date.month}/${payment.date.year}";
          final amountStr = "₹${payment.amount}";

          return Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.payment, color: Colors.white70, size: 28),
                const SizedBox(height: 6),
                Text(
                  amountStr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _glowTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 6,
            color: Colors.white.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  Widget _glassTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _userData == null
            ? const Center(
          child: Text(
            "Could not load profile.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProfileHeader(
                name: _userData!.name,
                email: _userData!.email,
                joined: _userData!.joined,
              ),
              const SizedBox(height: 30),

              _glowTitle("Payment History"),
              const SizedBox(height: 12),
              _buildPaymentHistory(),
              const SizedBox(height: 30),

              _glowTitle("Info & Support"),
              const SizedBox(height: 12),
              _glassTile(Icons.info_outline, "About Us", _openAboutUs),
              _glassTile(Icons.privacy_tip_outlined, "Privacy Policy", _openPrivacyPolicy),
              _glassTile(Icons.email_outlined, "Contact Us", _openContactUs),

              const SizedBox(height: 40),
              _AccountActions(onLogout: _logOut),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Profile Header ---
class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String joined;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.joined,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white24,
          child: Icon(Icons.person, size: 40, color: Colors.white70),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(fontSize: 14, color: Colors.white54),
        ),
        if (joined.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            "Joined on $joined",
            style: const TextStyle(fontSize: 14, color: Colors.white38),
          ),
        ],
      ],
    );
  }
}

// --- Account Actions ---
class _AccountActions extends StatelessWidget {
  final Future<void> Function() onLogout;

  const _AccountActions({
    required this.onLogout,
    super.key,
  });

  ButtonStyle _buttonStyle({Color background = Colors.white24}) {
    return ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => RitualFadeOverlay(onComplete: onLogout),
          ),
          icon: const Icon(Icons.logout),
          label: const Text("Log Out"),
          style: _buttonStyle(),
        ),
      ],
    );
  }
}

// --- Overlay Widget ---
class RitualFadeOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const RitualFadeOverlay({required this.onComplete, super.key});

  @override
  State<RitualFadeOverlay> createState() => _RitualFadeOverlayState();
}

class _RitualFadeOverlayState extends State<RitualFadeOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().whenComplete(() {
      Navigator.of(context).pop();
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        color: Colors.black.withOpacity(0.95),
        child: const Center(
          child: Icon(Icons.auto_awesome, size: 80, color: Colors.white70),
        ),
      ),
    );
  }
}
