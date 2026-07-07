import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/notification_models.dart';
import '../providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          if (unread > 0)
            IconButton(
              tooltip: 'Tanda semua dibaca',
              icon: const Icon(Icons.done_all_rounded),
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllRead();
                AppSnackbar.info(context, 'Semua notifikasi ditanda dibaca');
              },
            ),
          if (items.isNotEmpty)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'clear') {
                  ref.read(notificationsProvider.notifier).clearAll();
                  AppSnackbar.warning(context, 'Semua notifikasi dibersihkan');
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'clear', child: Text('Kosongkan semua')),
              ],
            ),
        ],
      ),
      body: items.isEmpty
          ? _EmptyState(context: context)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 76, endIndent: 12),
              itemBuilder: (context, i) {
                final n = items[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: const Color(0xFFC0392B),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    ref.read(notificationsProvider.notifier).remove(n.id);
                    AppSnackbar.info(context, 'Notifikasi dibuang');
                  },
                  child: _NotifTile(notification: n),
                ).animate().fadeIn(delay: (40 * i).ms);
              },
            ),
    );
  }
}

class _NotifTile extends ConsumerWidget {
  final AppNotification notification;
  const _NotifTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = notification;
    return Container(
      color: n.read ? null : n.category.color.withValues(alpha: 0.06),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () {
          ref.read(notificationsProvider.notifier).markRead(n.id);
          if (n.route != null) context.push(n.route!);
        },
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: n.category.color.withValues(alpha: 0.15),
          child: Icon(n.category.icon, color: n.category.color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                n.title,
                style: TextStyle(
                    fontWeight: n.read ? FontWeight.w500 : FontWeight.w700),
              ),
            ),
            Text(Formatters.relative(n.time),
                style: TextStyle(
                    fontSize: 12, color: context.colors.onSurfaceVariant)),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(n.body,
              style: TextStyle(color: context.colors.onSurfaceVariant)),
        ),
        trailing: n.read
            ? null
            : Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                    color: n.category.color, shape: BoxShape.circle),
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final BuildContext context;
  const _EmptyState({required this.context});

  @override
  Widget build(BuildContext _) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: context.colors.onSurfaceVariant),
          const SizedBox(height: 12),
          Text('Tiada notifikasi',
              style: context.texts.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Semua dah bersih 🎉',
              style: TextStyle(color: context.colors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
