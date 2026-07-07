import 'package:flutter/material.dart';

enum SnackType { success, error, info, warning }

/// Nicely styled, coloured, floating snackbars with an icon. Every user action
/// in the app routes feedback through here.
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    SnackType type = SnackType.info,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final (Color background, IconData icon) = switch (type) {
      SnackType.success => (const Color(0xFF1F8A50), Icons.check_circle_rounded),
      SnackType.error => (const Color(0xFFC0392B), Icons.error_rounded),
      SnackType.warning => (const Color(0xFFB9770E), Icons.warning_amber_rounded),
      SnackType.info => (scheme.inverseSurface, Icons.info_rounded),
    };
    final onBackground =
        type == SnackType.info ? scheme.onInverseSurface : Colors.white;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: background,
          elevation: 6,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: Row(
            children: [
              Icon(icon, color: onBackground, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: onBackground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void success(BuildContext c, String m) =>
      show(c, m, type: SnackType.success);
  static void error(BuildContext c, String m) =>
      show(c, m, type: SnackType.error);
  static void info(BuildContext c, String m) =>
      show(c, m, type: SnackType.info);
  static void warning(BuildContext c, String m) =>
      show(c, m, type: SnackType.warning);
}
