import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  Razorpay? _razorpay;
  late Function(PaymentSuccessResponse) _onSuccess;
  late Function(PaymentFailureResponse) _onError;
  Function(ExternalWalletResponse)? _onWallet;

  /// Initialize Razorpay and register event handlers
  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    Function(ExternalWalletResponse)? onWallet,
  }) {
    _razorpay = Razorpay();
    _onSuccess = onSuccess;
    _onError = onError;
    _onWallet = onWallet;

    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handleError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    debugPrint('🧿 Razorpay initialized and listeners attached.');
  }

  /// Dispose Razorpay instance and clear listeners
  void dispose() {
    _razorpay?.clear();
    debugPrint('🧹 Razorpay disposed.');
  }

  /// Open Razorpay checkout with provided options
  void openCheckout({
    required String keyId,
    required int amount, // in paise
    required String name,
    String description = 'Unlock your cosmic journey',
    String contact = '9876543210',
    String email = 'user@example.com',
    String themeColor = '#8A2BE2',
  }) {
    if (_razorpay == null) {
      debugPrint('⚠️ Razorpay not initialized. Call init() first.');
      return;
    }

    debugPrint('🔧 Checkout Params: key=$keyId, amount=$amount, name=$name');

    var options = {
      'key': keyId,
      'amount': amount,
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email,
      },
      'theme': {
        'color': themeColor,
      },
    };

    try {
      debugPrint('🚀 Opening Razorpay checkout...');
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('❌ Razorpay openCheckout error: $e');
    }
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    debugPrint('✅ Payment Success: ${response.paymentId}');
    _onSuccess(response);
  }

  void _handleError(PaymentFailureResponse response) {
    debugPrint('❌ Payment Error: ${response.code} | ${response.message}');
    _onError(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('💼 External Wallet Selected: ${response.walletName}');
    if (_onWallet != null) _onWallet!(response);
  }
}