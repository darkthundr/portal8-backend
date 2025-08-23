import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SessionLoader {
  /// Loads portal data and injects purchase status
  Future<List<Map<String, dynamic>>> loadSessionData() async {
    final jsonString = await rootBundle.loadString('assets/json/portal_data.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Map<String, dynamic>> sessionData = List<Map<String, dynamic>>.from(jsonList);

    final purchasedPortals = await _getPurchasedPortals();
    _injectPurchasesIntoSession(purchasedPortals, sessionData);

    return sessionData;
  }

  /// Retrieves purchased portal IDs from Firebase or local storage
  Future<List<String>> _getPurchasedPortals() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final cloudHistory = List<String>.from(doc.data()?['purchasedPortals'] ?? []);
      await prefs.setStringList('purchasedPortals', cloudHistory);
      return cloudHistory;
    } else {
      return prefs.getStringList('purchasedPortals') ?? [];
    }
  }

  /// Adds 'unlocked' flag to each portal based on purchase history
  void _injectPurchasesIntoSession(List<String> purchasedPortals, List<Map<String, dynamic>> sessionData) {
    for (final portal in sessionData) {
      final id = portal['id'];
      portal['unlocked'] = purchasedPortals.contains(id);
    }

    // Inject bonus portals dynamically if not present in JSON
    final bonusPortals = [
      {
        'id': 'portal_infinity',
        'title': 'Portal ∞',
        'subtitle': 'Transcend all dimensions',
        'image': 'assets/images/portal_infinity.jpg',
        'unlocked': purchasedPortals.contains('portal_infinity'),
      },
      {
        'id': 'ritual_bonus_1',
        'title': 'Bonus Ritual: Breath of Stars',
        'subtitle': 'Activate stellar memory',
        'image': 'assets/images/ritual1.jpg',
        'unlocked': purchasedPortals.contains('ritual_bonus_1'),
      },
      {
        'id': 'ritual_bonus_2',
        'title': 'Bonus Ritual: Cosmic Mirror',
        'subtitle': 'See your soul reflected',
        'image': 'assets/images/ritual2.jpg',
        'unlocked': purchasedPortals.contains('ritual_bonus_2'),
      },
      {
        'id': 'wallpaper_pack',
        'title': 'Cosmic Wallpapers',
        'subtitle': 'Download high-res cosmic art',
        'image': 'assets/images/wallpaper_pack.jpg',
        'unlocked': purchasedPortals.contains('wallpaper_pack'),
      },
      {
        'id': 'cosmic_theme',
        'title': 'Cosmic Theme',
        'subtitle': 'Enable full cosmic UI experience',
        'image': 'assets/images/cosmic_theme.jpg',
        'unlocked': purchasedPortals.contains('cosmic_theme'),
      },
    ];

    sessionData.addAll(bonusPortals);
  }
}