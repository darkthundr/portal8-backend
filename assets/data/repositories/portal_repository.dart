import 'dart:convert';
import 'package:flutter/services.dart';
import 'portal_data.dart'; // your model file

class PortalRepository {
  Future<PortalData> loadPortal(int portalNumber) async {
    final path = 'assets/portals/portal$portalNumber.json';
    final jsonString = await rootBundle.loadString(path);
    final jsonMap = jsonDecode(jsonString);
    return PortalData.fromJson(jsonMap);
  }

  Future<List<PortalData>> loadAllPortals() async {
    final List<PortalData> portals = [];
    for (int i = 1; i <= 8; i++) {
      portals.add(await loadPortal(i));
    }
    return portals;
  }
}