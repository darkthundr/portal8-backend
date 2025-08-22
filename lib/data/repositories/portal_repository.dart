import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/portal_data.dart';

class PortalRepository {
  Future<PortalData> loadPortal(String portalId) async {
    final String jsonString = await rootBundle.loadString('assets/portals/$portalId.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return PortalData.fromJson(jsonMap);
  }
}