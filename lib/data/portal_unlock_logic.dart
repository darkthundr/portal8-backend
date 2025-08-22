import 'package:flutter/material.dart';

class UnlockManager {
  final Set<int> unlockedPortals;

  UnlockManager({required this.unlockedPortals});

  bool isPortalUnlocked(int portalNumber) {
    // Free trial is always unlocked
    if (portalNumber == 0) return true;
    return unlockedPortals.contains(portalNumber);
  }

  void unlockPortal(int portalNumber) {
    unlockedPortals.add(portalNumber);
  }

  // Optional: Unlock all if full cosmic bundle bought
  void unlockAll() {
    unlockedPortals.addAll(List.generate(9, (i) => i));
  }
}
