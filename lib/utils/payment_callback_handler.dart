import 'package:flutter/material.dart';
import 'portal_unlock_service.dart';

class PaymentCallbackHandler {
  final _unlockService = PortalUnlockService();

  Future<void> handlePaymentSuccess(String paymentId) async {
    print("✅ Razorpay success: $paymentId");

    // Unlock bundle or individual portal
    await _unlockService.unlockBundle();

    // Optional: confirm ∞ unlock
    await _unlockService.maybeUnlockInfinity();
  }
}