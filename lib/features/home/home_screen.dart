import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/currency_provider.dart';
import '../../core/providers/navigation_provider.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/section_header.dart';
import '../notifications/providers/notification_providers.dart';
import 'widgets/stories_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final currency = ref.watch(currencyProvider);
    final unreadNotif = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, ${auth.name} 👋',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text('Selamat kembali',
                style: TextStyle(
                    fontSize: 12, color: context.colors.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unreadNotif > 0,
              label: Text('$unreadNotif'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      // Whole page scrolls vertically (scroll Y).
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Instagram-style stories — scrolls horizontally (scroll X).
          const StoriesBar(),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => context.push('/wallet'),
              child: _BalanceCard(currency: currency),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Quick actions'),
                _QuickActions(ref: ref),
                const SectionHeader(title: "What's new in Flutter 3.44"),
              ],
            ),
          ),
          const _WhatsNewRow(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Recent activity'),
                ..._recentActivity(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _recentActivity(BuildContext context) {
    final items = [
      (Icons.mail_rounded, 'GitHub', 'CI passed on main', const Color(0xFF24292E)),
      (Icons.chat_bubble_rounded, 'Aisyah', 'Sent you a message', const Color(0xFF6C4DF6)),
      (Icons.payments_rounded, 'Stripe', 'Payment RM149 received', const Color(0xFF635BFF)),
    ];
    return [
      for (final it in items)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: it.$4,
            child: Icon(it.$1, color: Colors.white, size: 20),
          ),
          title: Text(it.$2,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(it.$3),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => AppSnackbar.info(context, '${it.$2} — demo'),
        ),
    ];
  }
}

class _BalanceCard extends StatelessWidget {
  final Currency currency;
  const _BalanceCard({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C4DF6), Color(0xFF9B51E0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total balance',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            Formatters.money(12580.75, currency),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _stat(context, Icons.arrow_downward_rounded, 'Income',
                  Formatters.money(4200, currency)),
              const SizedBox(width: 24),
              _stat(context, Icons.arrow_upward_rounded, 'Spending',
                  Formatters.money(1830.5, currency)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.1);
  }

  Widget _stat(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white24,
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  final WidgetRef ref;
  const _QuickActions({required this.ref});

  @override
  Widget build(BuildContext context) {
    final actions = <(IconData, String, Color, VoidCallback)>[
      (Icons.person_rounded, 'Profile', const Color(0xFF00B8A9),
          () => context.push('/profile')),
      (Icons.chat_bubble_rounded, 'Chat', const Color(0xFF6C4DF6),
          () => ref.read(shellIndexProvider.notifier).set(1)),
      (Icons.mail_rounded, 'Email', const Color(0xFFEB5757),
          () => ref.read(shellIndexProvider.notifier).set(2)),
      (Icons.account_balance_wallet_rounded, 'Wallet', const Color(0xFF1F8A50),
          () => context.push('/wallet')),
      (Icons.local_shipping_rounded, 'Kurier', const Color(0xFFF2994A),
          () => context.push('/courier')),
      (Icons.map_rounded, 'Map', const Color(0xFF2D9CDB),
          () => context.push('/map')),
      (Icons.bar_chart_rounded, 'Charts', const Color(0xFF17A67B),
          () => ref.read(shellIndexProvider.notifier).set(3)),
      (Icons.calendar_month_rounded, 'Calendar', const Color(0xFFF2994A),
          () => context.push('/calendar')),
      (Icons.widgets_rounded, 'Widgets', const Color(0xFF2D9CDB),
          () => context.push('/components')),
      (Icons.shield_rounded, '2FA', const Color(0xFF9B51E0),
          () => context.push('/settings/2fa')),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: [
        for (final a in actions)
          Material(
            color: a.$3.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: a.$4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(a.$1, color: a.$3, size: 28),
                  const SizedBox(height: 8),
                  Text(a.$2,
                      style: TextStyle(
                          color: a.$3, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _WhatsNewRow extends StatelessWidget {
  const _WhatsNewRow();

  static const _items = [
    ('Impeller', 'Renderer default merentas platform untuk animasi lebih smooth.', Color(0xFF6C4DF6)),
    ('Material 3', 'Carousel, SearchBar, Badge, SegmentedButton siap pakai.', Color(0xFF17A67B)),
    ('Riverpod 3', 'Notifier API baru, lebih type-safe & senang test.', Color(0xFFEB5757)),
    ('DevTools', 'Profiling & inspector yang lagi laju.', Color(0xFFF2994A)),
  ];

  @override
  Widget build(BuildContext context) {
    // Card width scales with the screen so the row feels right on small phones
    // and tablets alike, while keeping the next card peeking to hint at scroll.
    final cardWidth =
        (MediaQuery.sizeOf(context).width * 0.6).clamp(200.0, 280.0).toDouble();
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final it = _items[i];
          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: it.$3.withValues(alpha: 0.12),
              border: Border.all(color: it.$3.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded, color: it.$3),
                const Spacer(),
                Text(it.$1,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: it.$3)),
                const SizedBox(height: 4),
                Text(it.$2,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
