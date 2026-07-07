import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/email_providers.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emails = ref.watch(emailProvider);
    final unread = ref.watch(unreadEmailCountProvider);
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text(
                '$unread unread',
                style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => AppSnackbar.info(context, 'Search — demo sahaja'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: emails.length,
        separatorBuilder: (_, _) =>
            const Divider(height: 1, indent: 82, endIndent: 12),
        itemBuilder: (context, i) {
          final e = emails[i];
          return Dismissible(
            key: ValueKey(e.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: const Color(0xFFC0392B),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              child: const Icon(Icons.delete_rounded, color: Colors.white),
            ),
            onDismissed: (_) {
              ref.read(emailProvider.notifier).delete(e.id);
              AppSnackbar.warning(context, 'Emel dari ${e.sender} dipadam');
            },
            child: ListTile(
              onTap: () {
                ref.read(emailProvider.notifier).markRead(e.id);
                context.push('/email/${e.id}');
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: e.avatarColor,
                child: Text(
                  e.sender.initials,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.sender,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight:
                            e.read ? FontWeight.w500 : FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    Formatters.relative(e.time),
                    style:
                        TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: e.read ? FontWeight.w400 : FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          e.preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(emailProvider.notifier).toggleStar(e.id);
                          AppSnackbar.info(
                            context,
                            e.starred ? 'Bintang dibuang' : 'Ditanda bintang ⭐',
                          );
                        },
                        child: Icon(
                          e.starred
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: e.starred
                              ? const Color(0xFFF2C94C)
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (50 * i).ms);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/email/compose'),
        icon: const Icon(Icons.edit_rounded),
        label: const Text('Compose'),
      ),
    );
  }
}
