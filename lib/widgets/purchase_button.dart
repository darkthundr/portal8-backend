import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:portal8/services/progress_service.dart';
import 'package:portal8/utils/shared_prefs_helper.dart';

class PurchaseButton extends StatefulWidget {
  final int portalNumber;
  final int priceInRupees;
  final String description;

  const PurchaseButton({
    Key? key,
    required this.portalNumber,
    required this.priceInRupees,
    required this.description,
  }) : super(key: key);

  @override
  State<PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<PurchaseButton> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_live_L8jwMD4kB7c9UW',
      'amount': widget.priceInRupees * 100,
      'name': 'Portal 8 Awakening',
      'description': widget.description,
      'prefill': {
        'contact': '',
        'email': ''
      },
      'theme': {
        'color': '#5b3fbc'
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Payment Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await SharedPrefsHelper.setPaidUser(true);
    await ProgressService().unlockPortal(widget.portalNumber);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✨ Portal Unlocked!')),
      );
      setState(() {});
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('❌ Payment Failed. Try again.')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet payment not supported.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _startPayment,
      child: Text("Unlock Now ₹${widget.priceInRupees}"),
    );
  }
}
