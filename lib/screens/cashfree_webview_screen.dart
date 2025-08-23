import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cosmic_nexus_screen.dart';

class CashfreeWebViewScreen extends StatefulWidget {
  final String sandboxUrl;
  final String liveUrl;

  const CashfreeWebViewScreen({
    Key? key,
    required this.sandboxUrl,
    required this.liveUrl,
  }) : super(key: key);

  @override
  State<CashfreeWebViewScreen> createState() => _CashfreeWebViewScreenState();
}

class _CashfreeWebViewScreenState extends State<CashfreeWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final selectedUrl = kReleaseMode ? widget.liveUrl : widget.sandboxUrl;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) async {
            if (url.contains("success")) {
              await _unlockBundlePortals();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CosmicNexusScreen()),
                );
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(selectedUrl));
  }

  Future<void> _unlockBundlePortals() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final unlocks = [
      ...List.generate(8, (i) => 'portal_${i + 1}'),
      'portal_infinity',
      'ritual_bonus_1',
      'ritual_bonus_2',
      'wallpaper_pack',
      'cosmic_theme',
      'advanced_practices',
      'infinite_scroll',
    ];

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'unlockedPortals': FieldValue.arrayUnion(unlocks),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}