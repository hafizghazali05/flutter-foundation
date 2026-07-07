import 'package:flutter/material.dart';

/// Central colour tokens. Kept separate from [ThemeData] so features and charts
/// can reference the same palette.
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF6C4DF6); // vivid violet

  // Semantic colours (snackbars, status).
  static const Color success = Color(0xFF1F8A50);
  static const Color error = Color(0xFFC0392B);
  static const Color warning = Color(0xFFB9770E);
  static const Color info = Color(0xFF2D6CDF);

  // Feature accents (dashboard cards / icons).
  static const Color chat = Color(0xFF6C4DF6);
  static const Color email = Color(0xFFEB5757);
  static const Color charts = Color(0xFF17A67B);
  static const Color components = Color(0xFFF2994A);
  static const Color security = Color(0xFF2D9CDB);

  /// Ordered palette used across every chart so series stay consistent.
  static const List<Color> chartPalette = [
    Color(0xFF6C4DF6),
    Color(0xFF17A67B),
    Color(0xFFFF6B6B),
    Color(0xFFFFC93C),
    Color(0xFF4D96FF),
    Color(0xFFEB5757),
  ];
}
