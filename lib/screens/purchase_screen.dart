import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'cosmic_nexus_screen.dart';
import 'payment_success_screen.dart';
import '../widgets/portal_card.dart';
import '../widgets/bundle_card.dart';
import '../services/payment_service.dart';

class PurchaseScreen extends StatefulWidget {
  final int? portalIndex;
  const PurchaseScreen({Key? key, this.portalIndex}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final Razorpay _razorpay = Razorpay();
  final User? user = FirebaseAuth.instance.currentUser;
  final paymentSvc = PaymentService();

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  List<String> _unlockedPortals = [];
  bool _isFetchingUnlocks = true;
  bool _isProcessingPayment = false;

  final bool isIndia = true;

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _listenToUnlockedPortals();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _listenToUnlockedPortals() {
    final uid = user?.uid;
    if (uid == null) return;

    FirebaseFirestore.instance.collection('users').doc(uid).snapshots().listen((doc) {
      final data = doc.data();
      if (data == null) return;

      List<String> portals = [];
      if (data['unlockedPortals'] is List) {
        portals = List<String>.from(data['unlockedPortals']);
      }

      final allPortalsUnlocked = List.generate(8, (i) => 'portal_${i + 1}')
          .every((id) => portals.contains(id));

      if (allPortalsUnlocked && !portals.contains('advanced_practices')) {
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'unlockedPortals': FieldValue.arrayUnion(['advanced_practices']),
        }, SetOptions(merge: true));
        portals.add('advanced_practices');
      }

      if (mounted) {
        setState(() {
          _unlockedPortals = portals;
          _isFetchingUnlocks = false;
        });
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _toast('✅ Payment Success: ${response.paymentId}');

    final uid = user?.uid;
    if (uid == null) return;

    final isBundle = widget.portalIndex == null;
    final unlocks = isBundle
        ? List.generate(8, (i) => 'portal_${i + 1}')
        : ['portal_${widget.portalIndex ?? 1}'];

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'unlockedPortals': FieldValue.arrayUnion(unlocks),
    }, SetOptions(merge: true));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          paymentId: response.paymentId!,
          isBundle: isBundle,
          portalIndex: widget.portalIndex ?? 1,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final msg = response.message ?? 'Unknown error';
    _toast('❌ Payment Failed: $msg');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _toast('Wallet Selected: ${response.walletName}');
  }

  void _toast(String msg) {
    if (!mounted) return;
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> _startRazorpayPayment({
    required bool isBundle,
    required int portalIndex,
  }) async {
    if (user == null) {
      _toast('Please sign in first');
      return;
    }

    try {
      setState(() => _isProcessingPayment = true);

      final uid = user!.uid;
      final order = await paymentSvc.createOrderOnServer(
        uid: uid,
        isIndia: isIndia,
        isBundle: isBundle,
        portalIndex: portalIndex,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('Server took too long to respond. Please try again.');
      });

      final price = paymentSvc.getPrice(
        isIndia: isIndia,
        isBundle: isBundle,
        portalIndex: portalIndex,
      );

      final options = {
        'key': 'rzp_test_R8SPavSwbFwtFT',
        'amount': price['amount'], // ✅ Send in rupees
        'currency': price['currency'],
        'display_amount': price['amount'],
        'display_currency': price['currency'],
        'name': isBundle ? 'Portal8 Cosmic Bundle' : 'Portal8 Portal $portalIndex',
        'description': isBundle ? 'All 8 portals + advanced' : 'Single portal access',
        'order_id': order['id'], // ✅ Razorpay returns 'id'
        'prefill': {
          'contact': user?.phoneNumber ?? '',
          'email': user?.email ?? '',
        },
        'theme': {'color': '#6C2BD9'},
      };

      _razorpay.open(options);
    } on TimeoutException catch (e) {
      _toast('Order error: ${e.message}');
    } catch (e) {
      _toast('Order error: $e');
    } finally {
      setState(() => _isProcessingPayment = false);
    }
  }

  Widget _portalSwiper() {
    if (_isFetchingUnlocks) return const Center(child: CircularProgressIndicator());
    final prices = PaymentService.portalPricesINR;

    return RepaintBoundary(
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: prices.length,
          itemBuilder: (context, index) {
            final portalNumber = index + 1;
            final price = prices[index];
            final portalId = 'portal_$portalNumber';
            final isUnlocked = _unlockedPortals.contains(portalId);

            return PortalCard(
              portalNumber: portalNumber,
              price: price,
              isUnlocked: isUnlocked,
              isIndia: true,
              onTap: () async {
                if (isUnlocked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CosmicNexusScreen()),
                  );
                } else {
                  await _startRazorpayPayment(isBundle: false, portalIndex: portalNumber);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _benefit(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white70)),
  );

  @override
  Widget build(BuildContext context) {
    final hasBundle = _unlockedPortals.length >= 8;
    final bundlePrice = PaymentService.bundlePriceINR;

    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        title: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Text('✨ Unlock Your Awakening'),
    ),
    backgroundColor: Colors.deepPurple,
    ),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const Center(
    child: FittedBox(
    fit: BoxFit.scaleDown,
    child: Text(
    '🪐 Choose Your Path',
    style: TextStyle(
    fontSize: 26,
    color: Colors.purpleAccent,
    fontWeight: FontWeight.bold,
    shadows: [
    Shadow(
    blurRadius: 12,
    color: Colors.purple,
    offset: Offset(0, 0),
    )
    ],
    ),
    ),
    ),
    ),
    const SizedBox(height: 32),
    _portalSwiper(),
    const SizedBox(height: 24),
    if (!hasBundle)
    BundleCard(
    price: bundlePrice,
    isUnlocked: hasBundle,
    isIndia: true,
    isLoading: _isProcessingPayment,
    onTap: () async {
      await _startRazorpayPayment(
        isBundle: true,
        portalIndex: (widget.portalIndex ?? 1),
      );
    },
    ),
      const SizedBox(height: 40),
      const Text(
        "🌟 Why Begin?",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      _benefit("🌿 Deep relaxation and inner peace"),
      _benefit("✨ Bliss beyond thought and form"),
      _benefit("🛡️ Freedom from anxiety and depression"),
      _benefit("🌞 A life lived fully, not just survived"),
      _benefit("🌀 A mythic journey that evolves with you"),
    ],
    ),
    ),
        ),
    );
  }
}