import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root of the Flutter Foundation template.
///
/// Everything is wired here: Riverpod is provided in [main], the theme mode is
/// watched so the dark/light toggle is instant, and navigation is handled by
/// go_router ([appRouter]).
class FoundationApp extends ConsumerWidget {
  const FoundationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Flutter Foundation',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: mode,
      routerConfig: appRouter,
    );
  }
}
