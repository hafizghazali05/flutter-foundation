import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/section_header.dart';
import '../data/courier_data.dart';
import '../data/courier_mock.dart';
import '../domain/courier_models.dart';
import '../providers/courier_providers.dart';

/// A shipment-booking form. On submit it generates a tracking number, records
/// the shipment, and jumps straight to the tracking view.
class ShippingForm extends ConsumerStatefulWidget {
  const ShippingForm({super.key});

  @override
  ConsumerState<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends ConsumerState<ShippingForm> {
  final _formKey = GlobalKey<FormState>();
  final _senderName = TextEditingController();
  final _senderPhone = TextEditingController();
  final _pickup = TextEditingController();
  final _recipientName = TextEditingController();
  final _recipientPhone = TextEditingController();
  final _dropoff = TextEditingController();

  double _weight = 1;
  int _service = 0;
  Courier _courier = kCouriers.first;
  bool _busy = false;

  static const _services = [
    ('Standard', 1.0, '2–4 hari bekerja'),
    ('Express', 1.8, '1–2 hari bekerja'),
    ('Same Day', 2.6, 'Hari yang sama'),
  ];

  @override
  void dispose() {
    _senderName.dispose();
    _senderPhone.dispose();
    _pickup.dispose();
    _recipientName.dispose();
    _recipientPhone.dispose();
    _dropoff.dispose();
    super.dispose();
  }

  double get _cost {
    final base = 5 + _weight * 2;
    return base * _services[_service].$2;
  }

  String _generateTrackingNo() {
    final stamp = DateTime.now().millisecondsSinceEpoch.toString();
    final tail = stamp.substring(stamp.length - 9);
    return '${_courier.badge}$tail';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackbar.error(context, 'Sila lengkapkan medan yang diperlukan');
      return;
    }
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final trackingNo = _generateTrackingNo();
    final shipment = buildShipment(_courier, trackingNo, atStation: 0);
    ref.read(shipmentsProvider.notifier).add(shipment);
    setState(() => _busy = false);

    AppSnackbar.success(context, 'Penghantaran ditempah: $trackingNo ✓');
    context.push('/courier/tracking', extra: shipment);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const SectionHeader(title: 'Penghantar'),
          TextFormField(
            controller: _senderName,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Nama penghantar diperlukan'
                : null,
            decoration: const InputDecoration(
              labelText: 'Nama penghantar',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _senderPhone,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                (v == null || v.length < 9) ? 'Nombor telefon tidak sah' : null,
            decoration: const InputDecoration(
              labelText: 'No. telefon',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _pickup,
            minLines: 2,
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Alamat pengambilan diperlukan'
                : null,
            decoration: const InputDecoration(
              labelText: 'Alamat pengambilan',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.my_location_rounded),
            ),
          ),
          const SectionHeader(title: 'Penerima'),
          TextFormField(
            controller: _recipientName,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Nama penerima diperlukan'
                : null,
            decoration: const InputDecoration(
              labelText: 'Nama penerima',
              prefixIcon: Icon(Icons.person_pin_circle_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _recipientPhone,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) =>
                (v == null || v.length < 9) ? 'Nombor telefon tidak sah' : null,
            decoration: const InputDecoration(
              labelText: 'No. telefon',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _dropoff,
            minLines: 2,
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Alamat penghantaran diperlukan'
                : null,
            decoration: const InputDecoration(
              labelText: 'Alamat penghantaran',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SectionHeader(title: 'Butiran parcel'),
          Row(
            children: [
              const Icon(Icons.scale_rounded),
              const SizedBox(width: 8),
              Text('Berat: ${_weight.toStringAsFixed(1)} kg',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Slider(
            value: _weight,
            min: 0.5,
            max: 20,
            divisions: 39,
            label: '${_weight.toStringAsFixed(1)} kg',
            onChanged: (v) => setState(() => _weight = v),
          ),
          const SizedBox(height: 4),
          SegmentedButton<int>(
            segments: [
              for (var i = 0; i < _services.length; i++)
                ButtonSegment(value: i, label: Text(_services[i].$1)),
            ],
            selected: {_service},
            onSelectionChanged: (s) => setState(() => _service = s.first),
          ),
          const SizedBox(height: 6),
          Text(_services[_service].$3,
              style: TextStyle(
                  fontSize: 12, color: context.colors.onSurfaceVariant)),
          const SizedBox(height: 16),
          const Text('Pilih kurier',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in kCouriers)
                ChoiceChip(
                  avatar: CircleAvatar(
                    backgroundColor: c.color,
                    child: Text(c.badge,
                        style: TextStyle(color: c.onColor, fontSize: 10)),
                  ),
                  label: Text(c.name),
                  selected: _courier.id == c.id,
                  onSelected: (_) => setState(() => _courier = c),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.colors.primaryContainer.withValues(alpha: 0.4),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded),
                const SizedBox(width: 10),
                const Text('Anggaran caj',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('RM ${_cost.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy ? null : _submit,
            icon: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: Colors.white))
                : const Icon(Icons.check_circle_outline_rounded),
            label: Text(_busy ? 'Memproses…' : 'Tempah penghantaran'),
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          ),
        ],
      ),
    );
  }
}
