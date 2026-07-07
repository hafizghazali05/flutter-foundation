import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/charts/charts_screen.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/email/presentation/inbox_screen.dart';
import '../../features/email/providers/email_providers.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../providers/navigation_provider.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  static const _tabs = [
    HomeScreen(),
    ChatListScreen(),
    InboxScreen(),
    ChartsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(shellIndexProvider);
    final unread = ref.watch(unreadEmailCountProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            ref.read(shellIndexProvider.notifier).set(i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.mail_outline_rounded),
            ),
            selectedIcon: const Icon(Icons.mail_rounded),
            label: 'Email',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Charts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
