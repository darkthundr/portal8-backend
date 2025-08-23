import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralSystem {
  static Future<void> handleIncomingReferralLink() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      final referrer = deepLink.queryParameters['ref'];
      if (referrer != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('referrer', referrer);
        print('Referral from: $referrer');
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData dynamicLinkData) async {
      final Uri? deepLink = dynamicLinkData.link;
      if (deepLink != null) {
        final referrer = deepLink.queryParameters['ref'];
        if (referrer != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('referrer', referrer);
          print('Dynamic link referral from: $referrer');
        }
      }
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }
}
