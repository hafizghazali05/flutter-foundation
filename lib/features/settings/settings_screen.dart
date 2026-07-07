import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/currency_provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/app_snackbar.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final currency = ref.watch(currencyProvider);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Profile header — tap to open the full profile screen.
          InkWell(
            onTap: () => context.push('/profile'),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: scheme.primary,
                    child: Text(
                      auth.name.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auth.name,
                            style: context.texts.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text(auth.email,
                            style:
                                TextStyle(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),

          const _GroupLabel('Preferences'),
          SwitchListTile(
            secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark mode'),
            subtitle: Text(isDark ? 'On' : 'Off'),
            value: isDark,
            onChanged: (v) {
              ref
                  .read(themeModeProvider.notifier)
                  .set(v ? ThemeMode.dark : ThemeMode.light);
              AppSnackbar.info(context, v ? 'Dark mode on 🌙' : 'Light mode on ☀️');
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange_rounded),
            title: const Text('Currency'),
            trailing: Text('${currency.flag} ${currency.code}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => context.push('/settings/currency'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (v) {
              setState(() => _notifications = v);
              AppSnackbar.info(
                  context, v ? 'Notifikasi dihidupkan' : 'Notifikasi dimatikan');
            },
          ),

          const _GroupLabel('Security'),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: const Text('Two-factor authentication'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/settings/2fa'),
          ),

          const _GroupLabel('More'),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Calendar'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/calendar'),
          ),
          ListTile(
            leading: const Icon(Icons.widgets_outlined),
            title: const Text('Components gallery'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/components'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded),
            title: const Text('FAQ & Help'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/settings/faq'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About'),
            subtitle: const Text('Flutter Foundation • v1.0.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Flutter Foundation',
              applicationVersion: '1.0.0',
              applicationLegalese: 'Mock template • Flutter 3.44',
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error.withValues(alpha: 0.5)),
                minimumSize: const Size.fromHeight(52),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log out'),
              onPressed: () => _confirmLogout(context),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Anda pasti nak log keluar dari akaun ni?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(authProvider.notifier).logout();
              AppSnackbar.success(context, 'Berjaya log keluar');
              context.go('/login');
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
