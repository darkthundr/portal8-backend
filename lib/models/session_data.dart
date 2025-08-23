import 'package:flutter/cupertino.dart';

class SessionData {
  final String title;
  final IconData icon;
  final bool isCompleted;
  final String portalName;

  SessionData({
    required this.title,
    required this.icon,
    this.isCompleted = false,
    required this.portalName,
  });
}