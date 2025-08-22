// TODO Implement this library.

import 'package:flutter/material.dart';

class Portal {
  final String id;
  final String title;
  final Color color;

  Portal({required this.id, required this.title, required this.color});

  factory Portal.fromJson(Map<String, dynamic> json) {
    return Portal(
      id: json['id'],
      title: json['title'],
      color: _hexToColor(json['color']),
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}