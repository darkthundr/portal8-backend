import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

class CashfreeTestScreen extends StatefulWidget {
  @override
  _CashfreeTestScreenState createState() => _CashfreeTestScreenState();
}

class _CashfreeTestScreenState extends State<CashfreeTestScreen> {
  late CFPaymentGatewayService _cfPaymentGatewayService;

  @override
  void initState() {
    super.initState();
    _cfPaymentGatewayService = CFPaymentGatewayService();
    _cfPaymentGatewayService.setCallback(_onSuccess, _onError);
  }

  void _onSuccess(String orderId) {
    print("✅ Payment Success: $orderId");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Success: $orderId")),
    );
  }

  void _onError(CFErrorResponse error, String orderId) {
    print("❌ Payment Error: ${error.getMessage()}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Error: ${error.getMessage()}")),
    );
  }

  void _launchCashfreeTest() {
    print("🧪 Test button tapped");

    try {
      final session = CFSessionBuilder()
          .setEnvironment(CFEnvironment.SANDBOX) // Use PRODUCTION for live
          .setOrderId("test_order_${DateTime.now().millisecondsSinceEpoch}")
          .setPaymentSessionId("your_valid_sandbox_token_here") // Replace this
          .build();

      final checkout = CFWebCheckoutPaymentBuilder()
          .setSession(session)
          .build();

      print("🚀 Launching Cashfree SDK...");
      _cfPaymentGatewayService.doPayment(checkout);
      print("✅ SDK doPayment called");
    } on CFException catch (e) {
      print("❌ SDK Exception: ${e.message}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SDK Error: ${e.message}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cashfree SDK Test")),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchCashfreeTest,
          child: Text("Launch Cashfree Payment"),
        ),
      ),
    );
  }
}