import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'purchase_screen.dart';
import 'cosmic_nexus_screen.dart';

class IndividualPortalScreen extends StatefulWidget {
  final int portalIndex;

  const IndividualPortalScreen({Key? key, required this.portalIndex}) : super(key: key);

  @override
  State<IndividualPortalScreen> createState() => _IndividualPortalScreenState();
}

class _IndividualPortalScreenState extends State<IndividualPortalScreen> {
  List<String> _unlockedPortals = [];
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _fetchUnlockedPortals();
  }

  Future<void> _fetchUnlockedPortals() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data();
    setState(() {
      _unlockedPortals =
      data != null && data['unlockedPortals'] != null ? List<String>.from(data['unlockedPortals']) : [];
      _isFetching = false;
    });
  }

  void _handlePortalTap() {
    final portalId = 'portal_${widget.portalIndex}';
    final isUnlocked = _unlockedPortals.contains(portalId);

    if (isUnlocked) {
      // If already unlocked, go to Cosmic Nexus
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CosmicNexusScreen()));
    } else {
      // Otherwise, redirect to Purchase Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PurchaseScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final portalId = 'portal_${widget.portalIndex}';
    final isUnlocked = _unlockedPortals.contains(portalId);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isUnlocked ? 'Portal ${widget.portalIndex} Unlocked' : 'Portal ${widget.portalIndex}'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handlePortalTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isUnlocked ? Colors.greenAccent : Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: Text(
            isUnlocked ? 'Enter Cosmic Nexus' : 'Unlock Portal ${widget.portalIndex}',
          ),
        ),
      ),
    );
  }
}
