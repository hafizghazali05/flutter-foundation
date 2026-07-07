import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/wallet_models.dart';
import '../providers/wallet_providers.dart';

/// Opens the withdrawal flow as a modal sheet.
Future<void> showWithdrawSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _WithdrawSheet(),
  );
}

class _WithdrawSheet extends ConsumerStatefulWidget {
  const _WithdrawSheet();

  @override
  ConsumerState<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends ConsumerState<_WithdrawSheet> {
  final _amount = TextEditingController();
  final _account = TextEditingController();
  Bank? _bank;
  bool _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    _account.dispose();
    super.dispose();
  }

  double get _amountValue => double.tryParse(_amount.text.trim()) ?? 0;

  Future<void> _confirm(double balance) async {
    if (_amountValue < 10) {
      AppSnackbar.error(context, 'Pengeluaran minimum RM 10');
      return;
    }
    if (_amountValue > balance) {
      AppSnackbar.error(context, 'Baki tidak mencukupi');
      return;
    }
    if (_bank == null) {
      AppSnackbar.error(context, 'Sila pilih bank');
      return;
    }
    if (_account.text.trim().length < 6) {
      AppSnackbar.error(context, 'Nombor akaun tidak sah');
      return;
    }
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final ok = ref
        .read(walletProvider.notifier)
        .withdraw(_amountValue, _bank!.name, _account.text.trim());
    Navigator.of(context).pop();
    if (ok) {
      AppSnackbar.success(
          context, 'Pengeluaran ${formatRm(_amountValue)} diproses ✓');
    } else {
      AppSnackbar.error(context, 'Baki tidak mencukupi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(walletProvider).balance;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const Text('Pengeluaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Baki tersedia: ${formatRm(balance)}',
              style: TextStyle(color: context.colors.onSurfaceVariant)),
          const SizedBox(height: 16),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            onChanged: (_) => setState(() {}),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              prefixText: 'RM ',
              prefixStyle: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC0392B)),
              hintText: '0.00',
              border: const OutlineInputBorder(),
              suffixIcon: TextButton(
                onPressed: () => setState(
                    () => _amount.text = balance.toStringAsFixed(2)),
                child: const Text('Semua'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Bank penerima',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final b in kFpxBanks)
                ChoiceChip(
                  label: Text(b.name),
                  selected: _bank == b,
                  onSelected: (_) => setState(() => _bank = b),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _account,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Nombor akaun',
              prefixIcon: Icon(Icons.account_balance_rounded),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFC0392B)),
              onPressed: _busy ? null : () => _confirm(balance),
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.4, color: Colors.white))
                  : const Text('Keluarkan wang'),
            ),
          ),
        ],
      ),
    );
  }
}
