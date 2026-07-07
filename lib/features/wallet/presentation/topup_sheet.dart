import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../domain/wallet_models.dart';
import '../providers/wallet_providers.dart';

/// Opens the top-up flow as a scrollable modal sheet.
Future<void> showTopupSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _TopupSheet(),
  );
}

class _TopupSheet extends ConsumerStatefulWidget {
  const _TopupSheet();

  @override
  ConsumerState<_TopupSheet> createState() => _TopupSheetState();
}

class _TopupSheetState extends ConsumerState<_TopupSheet> {
  final _amount = TextEditingController();
  final _cardNo = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _phone = TextEditingController();

  TopupMethod _method = TopupMethod.fpx;
  Bank? _bank;
  bool _busy = false;

  static const _quick = [10, 30, 50, 100, 200];

  @override
  void dispose() {
    _amount.dispose();
    _cardNo.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _phone.dispose();
    super.dispose();
  }

  double get _amountValue => double.tryParse(_amount.text.trim()) ?? 0;

  String? _validationError() {
    if (_amountValue < 1) return 'Masukkan jumlah sekurang-kurangnya RM 1';
    switch (_method) {
      case TopupMethod.card:
        final digits = _cardNo.text.replaceAll(' ', '');
        if (digits.length < 16) return 'Nombor kad tidak lengkap';
        if (_expiry.text.length < 5) return 'Tarikh luput tidak sah';
        if (_cvv.text.length < 3) return 'CVV tidak sah';
      case TopupMethod.fpx:
        if (_bank == null) return 'Sila pilih bank';
      case TopupMethod.grabpay:
        if (_phone.text.trim().length < 9) return 'Nombor telefon tidak sah';
    }
    return null;
  }

  Future<void> _confirm() async {
    final error = _validationError();
    if (error != null) {
      AppSnackbar.error(context, error);
      return;
    }
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final detail = switch (_method) {
      TopupMethod.card => '•••• ${_cardNo.text.replaceAll(' ', '').substring(12)}',
      TopupMethod.fpx => _bank!.name,
      TopupMethod.grabpay => _phone.text.trim(),
    };
    ref.read(walletProvider.notifier).topup(_amountValue, _method, detail: detail);

    Navigator.of(context).pop();
    AppSnackbar.success(
        context, 'Top up ${formatRm(_amountValue)} berjaya ✓');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            const Text('Top Up Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),

            // Amount.
            TextField(
              controller: _amount,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) => setState(() {}),
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w700),
              decoration: const InputDecoration(
                prefixText: 'RM ',
                prefixStyle: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6C4DF6)),
                hintText: '0.00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final q in _quick)
                  ActionChip(
                    label: Text('RM $q'),
                    onPressed: () =>
                        setState(() => _amount.text = q.toStringAsFixed(0)),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Kaedah pembayaran',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final m in TopupMethod.values) _methodTile(m),
            const SizedBox(height: 16),

            _methodFields(),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _confirm,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.4, color: Colors.white))
                    : Text(_amountValue >= 1
                        ? 'Top up ${formatRm(_amountValue)}'
                        : 'Top up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodTile(TopupMethod m) {
    final selected = _method == m;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() => _method = m),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? m.color : context.colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
            color: selected ? m.color.withValues(alpha: 0.08) : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: m.color.withValues(alpha: 0.15),
                child: Icon(m.icon, color: m.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(m.label,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? m.color : context.colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _methodFields() {
    switch (_method) {
      case TopupMethod.card:
        return Column(
          children: [
            TextField(
              controller: _cardNo,
              keyboardType: TextInputType.number,
              inputFormatters: [_CardNumberFormatter()],
              decoration: const InputDecoration(
                labelText: 'Nombor kad',
                hintText: '4242 4242 4242 4242',
                prefixIcon: Icon(Icons.credit_card_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiry,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_ExpiryFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'MM/YY',
                      prefixIcon: Icon(Icons.event_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvv,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      counterText: '',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      case TopupMethod.fpx:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih bank',
                style: TextStyle(fontWeight: FontWeight.w600)),
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
          ],
        );
      case TopupMethod.grabpay:
        return Column(
          children: [
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Nombor telefon GrabPay',
                hintText: '01X-XXX XXXX',
                prefixIcon: Icon(Icons.phone_rounded),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda akan diarahkan ke aplikasi Grab untuk sahkan pembayaran.',
              style: TextStyle(
                  fontSize: 12, color: context.colors.onSurfaceVariant),
            ),
          ],
        );
    }
  }
}

/// Groups card digits into blocks of four: `4242 4242 4242 4242`.
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits =
        newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed = digits.length > 16 ? digits.substring(0, 16) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < trimmed.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(trimmed[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Formats expiry as `MM/YY`.
class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final trimmed = digits.length > 4 ? digits.substring(0, 4) : digits;
    final text = trimmed.length >= 3
        ? '${trimmed.substring(0, 2)}/${trimmed.substring(2)}'
        : trimmed;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
