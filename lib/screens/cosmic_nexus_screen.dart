import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portal8/screens/purchase_screen.dart';

import '../models/portal_model.dart';
import 'portal0_chapter_swiper.dart';
import 'portal_screen.dart';
import 'infinity_invocation_screen.dart';
import '../widgets/animated_portal_tile.dart';
import 'individual_portal_screen.dart';

class CosmicNexusScreen extends StatefulWidget {
  const CosmicNexusScreen({super.key});

  @override
  State<CosmicNexusScreen> createState() => _CosmicNexusScreenState();
}

class _CosmicNexusScreenState extends State<CosmicNexusScreen> {
  List<Portal> portals = [];
  List<String> unlockedPortals = [];
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenUnlockedPortals();
    loadPortals();
  }

  void _listenUnlockedPortals() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((doc) {
      setState(() {
        unlockedPortals = List<String>.from(doc.data()?['unlockedPortals'] ?? []);
      });
      debugPrint("🔓 Live unlocked portals: $unlockedPortals");
    });
  }

  Future<void> loadPortals() async {
    try {
      setState(() => isLoading = true);

      final data = await rootBundle.loadString('assets/portals/portal_data.json');
      final List<dynamic> jsonList = json.decode(data);
      validatePortals(jsonList);

      final uniquePortals = <String, dynamic>{};
      for (var portal in jsonList) {
        final id = portal['id'];
        if (id != null && !uniquePortals.containsKey(id)) {
          uniquePortals[id] = portal;
        }
      }
      final cleanedList = uniquePortals.values.toList();

      // Add Infinite Portal manually
      cleanedList.add({
        "id": "infinity",
        "title": "∞ Infinite Portal",
        "color": "#8A2BE2",
      });

      setState(() {
        portals = cleanedList.map((json) => Portal.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error loading portal data: $e");
      setState(() {
        errorMessage = "Failed to load portals. Check asset path and pubspec.yaml.";
        isLoading = false;
      });
    }
  }

  /// Normalize portal ID to match Firestore format
  String _normalizePortalId(String id) {
    if (id == 'infinity') return 'portal_infinity';

    final match = RegExp(r'^portal(\d)$').firstMatch(id);
    return match != null ? 'portal_${match[1]}' : id;
  }

  bool _isUnlocked(String portalId) {
    if (portalId == 'portal0') return true;

    final normalized = _normalizePortalId(portalId);
    final alternate = portalId.replaceAll('_', '');

    final isUnlocked = unlockedPortals.contains(normalized) ||
        unlockedPortals.contains(portalId) ||
        unlockedPortals.contains(alternate);

    debugPrint('🔍 Checking unlock for: $portalId → $normalized | Match: $isUnlocked');
    return isUnlocked;
  }

  void _handlePortalTap(Portal portal) {
    final unlocked = _isUnlocked(portal.id);

    if (portal.id == 'portal0') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Portal0ChapterSwiper()));
    } else if (portal.id == 'infinity') {
      if (unlocked) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InfinityInvocationScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const IndividualPortalScreen(portalIndex: 999),
        ));
      }
    } else if (RegExp(r'^portal[1-8]$').hasMatch(portal.id)) {
      if (unlocked) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => PortalScreen(portalId: portal.id),
        ));
      } else {
        final index = int.tryParse(portal.id.replaceFirst('portal', '')) ?? 1;
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => PurchaseScreen(portalIndex: index),
        ));
      }
    }
  }

  void validatePortals(List<dynamic> jsonList) {
    final seenIds = <String>{};
    for (var i = 0; i < jsonList.length; i++) {
      final portal = jsonList[i];
      final id = portal['id'];
      final title = portal['title'];
      final color = portal['color'];

      if (id == null || id.toString().trim().isEmpty) {
        debugPrint("❌ Portal at index $i is missing a valid 'id'.");
      } else if (seenIds.contains(id)) {
        debugPrint("⚠️ Duplicate portal ID found: '$id' at index $i.");
      } else {
        seenIds.add(id);
      }

      if (title == null || title.toString().trim().isEmpty) {
        debugPrint("⚠️ Portal '$id' is missing a title.");
      }

      if (color == null || !RegExp(r'^#(?:[0-9a-fA-F]{6})$').hasMatch(color)) {
        debugPrint("⚠️ Portal '$id' has invalid color format: '$color'.");
      }
    }

    debugPrint("✅ Validation complete. ${seenIds.length} unique portals found.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🪐 Cosmic Nexus"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(color: Colors.redAccent, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: portals.length,
        itemBuilder: (context, index) {
          final portal = portals[index];
          final unlocked = _isUnlocked(portal.id);

          return Stack(
            children: [
              AnimatedPortalTile(
                portal: portal,
                delay: Duration(milliseconds: 100 * index),
                onTap: () => _handlePortalTap(portal),
              ),
              if (portal.id != 'portal0')
                Positioned(
                  right: 8,
                  top: 8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Container(
                      key: ValueKey(unlocked),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: unlocked
                            ? [BoxShadow(color: Colors.greenAccent, blurRadius: 12)]
                            : [],
                      ),
                      child: Icon(
                        unlocked ? Icons.lock_open : Icons.lock,
                        color: unlocked ? Colors.greenAccent : Colors.white70,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              if (portal.id != 'portal0')
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Text(
                    unlocked ? 'Unlocked' : 'Locked',
                    style: TextStyle(
                      color: unlocked ? Colors.greenAccent : Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}