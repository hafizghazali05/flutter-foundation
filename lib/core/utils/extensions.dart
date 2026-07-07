import 'package:flutter/material.dart';

/// Small quality-of-life extensions used throughout the UI.
extension ContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get texts => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Size get screen => MediaQuery.sizeOf(this);
}

extension StringX on String {
  /// "Aisyah Rahman" -> "AR", "hafiz" -> "HA".
  String get initials {
    final parts =
        trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final p = parts.first;
      return (p.length >= 2 ? p.substring(0, 2) : p).toUpperCase();
    }
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
