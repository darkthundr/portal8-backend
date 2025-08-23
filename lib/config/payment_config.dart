import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class PaymentConfig {
  // Razorpay Keys from .env
  static String get razorpayKey => dotenv.env['RAZORPAY_KEY'] ?? '';
  static String get razorpaySecret => dotenv.env['RAZORPAY_SECRET'] ?? '';

  // Cashfree Keys from Firebase Remote Config
  static Future<Map<String, String>> getCashfreeKeys() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 5),
    ));

    await remoteConfig.fetchAndActivate();

    final appId = remoteConfig.getString('CASHFREE_APP_ID');
    final secret = remoteConfig.getString('CASHFREE_SECRET');
    final mode = remoteConfig.getString('CASHFREE_MODE'); // "TEST" or "PROD"

    return {
      'appId': appId,
      'secret': secret,
      'mode': mode,
    };
  }
}
