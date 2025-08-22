import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../utils/country_helper.dart';
import '../config/pricing.dart';
import '../services/referral_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String productId; // e.g., 'portal_1'
  const CheckoutScreen({super.key, required this.productId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final PaymentService _paymentService = PaymentService();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String region = "GLOBAL";
  bool _loadingUser = true;
  bool _hasReferralFree = false;

  @override
  void initState() {
    super.initState();
    _paymentService.initListeners(context);
    _init();
  }

  Future<void> _init() async {
    await ReferralService().ensureReferralProfile();
    final r = await CountryHelper.detectUserRegion();
    await _loadUserFlags();
    setState(() {
      region = r;
      _loadingUser = false;
    });
  }

  Future<void> _loadUserFlags() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final snap = await _db.collection('users').doc(uid).get();
    final data = snap.data() ?? {};
    _hasReferralFree = (data['hasReferralFree'] ?? false) == true;
  }

  @override
  Widget build(BuildContext context) {
    final price = PricingConfig.prices[region]![widget.productId];
    final currency = PricingConfig.prices[region]!["currency"];

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Buy ${widget.productId.toUpperCase()}",
                  style: const TextStyle(fontSize: 22)),

              const SizedBox(height: 12),

              if (_hasReferralFree)
                Text("Eligible for FREE via referral 🎁",
                    style: const TextStyle(
                        fontSize: 16, color: Colors.greenAccent))
              else
                Text("$price $currency",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 24),

              if (_hasReferralFree)
                ElevatedButton.icon(
                  onPressed: () async {
                    final msg = await ReferralService()
                        .consumeReferralFreeAndUnlock(widget.productId);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(msg)));
                    if (msg.startsWith('Unlocked')) {
                      Navigator.pop(context, true); // success
                    }
                  },
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text("Claim Free Unlock"),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    _paymentService.openCheckout(
                      region: region,
                      productId: widget.productId,
                    );
                  },
                  child: const Text("Pay with Razorpay"),
                ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  // open the referral apply sheet anywhere in your app
                  // (see previous section)
                  // Example if you have it wired here:
                  // showModalBottomSheet(...)
                },
                child: const Text("Have a referral code?"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _paymentService.dispose();
    super.dispose();
  }
}
