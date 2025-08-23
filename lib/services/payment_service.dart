import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  /// INR per-portal prices
  static const List<int> portalPricesINR = [199, 249, 299, 349, 399, 449, 499, 499];
  static const int bundlePriceINR = 1899;

  /// USD per-portal prices (≈ triple)
  static const List<int> portalPricesUSD = [10, 12, 13, 14, 15, 16, 17, 17];
  static const int bundlePriceUSD = 79;

  /// Backend base URL (update if deployed)
  final String serverBaseUrl = 'https://portal8-backend.onrender.com';

  /// Get price and currency for a given selection
  Map<String, dynamic> getPrice({
    required bool isIndia,
    required bool isBundle,
    required int portalIndex, // 1..8
  }) {
    final currency = isIndia ? 'INR' : 'USD';
    if (isBundle) {
      final amount = isIndia ? bundlePriceINR : bundlePriceUSD;
      return {'amount': amount, 'currency': currency};
    } else {
      final idx = (portalIndex.clamp(1, 8)) - 1;
      final amount = isIndia ? portalPricesINR[idx] : portalPricesUSD[idx];
      return {'amount': amount, 'currency': currency};
    }
  }

  /// Create Razorpay order via backend
  Future<Map<String, dynamic>> createOrderOnServer({
    required String uid,
    required bool isIndia,
    required bool isBundle,
    required int portalIndex,
  }) async {
    final price = getPrice(
      isIndia: isIndia,
      isBundle: isBundle,
      portalIndex: portalIndex,
    );

    final url = Uri.parse('$serverBaseUrl/createorder');

    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': price['amount'], // ✅ Send in rupees
          'currency': price['currency'],
          'receipt': 'receipt_${DateTime.now().millisecondsSinceEpoch}',
        }),
      ).timeout(const Duration(seconds: 30)); // ⏱️ Increased timeout

      debugPrint('🔁 Server response: ${resp.statusCode} ${resp.body}');

      if (resp.statusCode != 200) {
        throw Exception('Server error: ${resp.statusCode} ${resp.body}');
      }

      final data = jsonDecode(resp.body);
      if (data['id'] == null) {
        throw Exception('Order creation failed: ${resp.body}');
      }

      return Map<String, dynamic>.from(data);
    } catch (e) {
      debugPrint('❌ Order creation exception: $e');
      throw Exception('Order error: $e');
    }
  }
}