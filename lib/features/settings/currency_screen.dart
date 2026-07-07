import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/currency_provider.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/app_snackbar.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Currency')),
      body: RadioGroup<String>(
        groupValue: selected.code,
        onChanged: (code) {
          if (code == null) return;
          final c = kCurrencies.firstWhere((e) => e.code == code);
          ref.read(currencyProvider.notifier).select(c);
          AppSnackbar.success(context, 'Mata wang ditukar ke ${c.name}');
        },
        child: ListView(
          children: [
            for (final c in kCurrencies)
              RadioListTile<String>(
                value: c.code,
                secondary: Text(c.flag, style: const TextStyle(fontSize: 26)),
                title: Text('${c.code} — ${c.name}'),
                subtitle: Text(
                  'Symbol: ${c.symbol}',
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
