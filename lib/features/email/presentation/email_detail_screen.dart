import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../providers/email_providers.dart';

class EmailDetailScreen extends ConsumerWidget {
  final String emailId;
  const EmailDetailScreen({super.key, required this.emailId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailProvider.notifier).byId(emailId);
    final scheme = context.colors;

    if (email == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Emel tidak dijumpai')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              email.starred ? Icons.star_rounded : Icons.star_border_rounded,
              color: email.starred ? const Color(0xFFF2C94C) : null,
            ),
            onPressed: () {
              ref.read(emailProvider.notifier).toggleStar(email.id);
              AppSnackbar.info(
                context,
                email.starred ? 'Bintang dibuang' : 'Ditanda bintang ⭐',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () {
              ref.read(emailProvider.notifier).delete(email.id);
              context.pop();
              AppSnackbar.warning(context, 'Emel dipadam');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            email.subject,
            style: context.texts.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              for (final l in email.labels)
                Chip(
                  label: Text(l),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: email.avatarColor,
                child: Text(
                  email.sender.initials,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(email.sender,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      email.senderEmail,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                Formatters.date(email.time),
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const Divider(height: 32),
          Text(email.body, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      AppSnackbar.success(context, 'Reply — demo sahaja'),
                  icon: const Icon(Icons.reply_rounded),
                  label: const Text('Reply'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      AppSnackbar.info(context, 'Forward — demo sahaja'),
                  icon: const Icon(Icons.forward_rounded),
                  label: const Text('Forward'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
