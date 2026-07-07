import 'package:flutter/material.dart';

import '../../core/utils/extensions.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_snackbar.dart';

/// Template 2FA flow (UI only). Enable the switch, "scan" the QR, enter a code.
class TwoFactorScreen extends StatefulWidget {
  const TwoFactorScreen({super.key});

  @override
  State<TwoFactorScreen> createState() => _TwoFactorScreenState();
}

class _TwoFactorScreenState extends State<TwoFactorScreen> {
  bool _enabled = false;
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Two-factor auth')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enable 2FA',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Tambah lapisan keselamatan pada akaun'),
              value: _enabled,
              onChanged: (v) {
                setState(() => _enabled = v);
                AppSnackbar.info(
                    context, v ? '2FA diaktifkan (demo)' : '2FA dimatikan');
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _enabled ? 1 : 0.4,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_enabled,
              child: Column(
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        const Text('1. Scan QR ni dengan app authenticator',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: scheme.outlineVariant, width: 1),
                          ),
                          child: const Icon(Icons.qr_code_2_rounded,
                              size: 140, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          'JBSWY3DPEHPK3PXP',
                          style: TextStyle(
                            fontFeatures: const [],
                            letterSpacing: 2,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('2. Masukkan kod 6-digit',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _code,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, letterSpacing: 8),
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: '••••••',
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppButton(
                          label: 'Verify & activate',
                          icon: Icons.verified_user_rounded,
                          onPressed: () {
                            if (_code.text.trim().length != 6) {
                              AppSnackbar.error(
                                  context, 'Masukkan kod 6-digit dulu');
                              return;
                            }
                            AppSnackbar.success(
                                context, '2FA berjaya diaktifkan ✓ (demo)');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
