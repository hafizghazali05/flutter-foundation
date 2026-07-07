import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/section_header.dart';
import '../data/courier_data.dart';
import '../data/courier_mock.dart';
import '../domain/courier_models.dart';
import '../providers/courier_providers.dart';
import 'shipping_form.dart';

class CourierScreen extends StatelessWidget {
  const CourierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Penghantaran Kurier'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Jejak', icon: Icon(Icons.travel_explore_rounded)),
              Tab(text: 'Hantar', icon: Icon(Icons.add_box_rounded)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_TrackTab(), ShippingForm()],
        ),
      ),
    );
  }
}

class _TrackTab extends ConsumerStatefulWidget {
  const _TrackTab();

  @override
  ConsumerState<_TrackTab> createState() => _TrackTabState();
}

class _TrackTabState extends ConsumerState<_TrackTab> {
  final _tracking = TextEditingController();

  @override
  void dispose() {
    _tracking.dispose();
    super.dispose();
  }

  void _track(Courier courier) {
    final no = _tracking.text.trim();
    if (no.isEmpty) {
      AppSnackbar.error(context, 'Sila masukkan nombor penjejakan');
      return;
    }
    final shipment = buildShipment(courier, no);
    ref.read(shipmentsProvider.notifier).add(shipment);
    context.push('/courier/tracking', extra: shipment);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedCourierProvider);
    final recent = ref.watch(shipmentsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
      children: [
        Text('${kCouriers.length} kurier utama Malaysia disokong',
            style: TextStyle(color: context.colors.onSurfaceVariant)),
        const SectionHeader(title: '1. Pilih kurier'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in kCouriers)
              _CourierChip(
                courier: c,
                selected: selected?.id == c.id,
                onTap: () =>
                    ref.read(selectedCourierProvider.notifier).select(c),
              ),
          ],
        ),
        const SectionHeader(title: '2. Masukkan nombor penjejakan'),
        TextField(
          controller: _tracking,
          enabled: selected != null,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: selected == null
                ? 'Pilih kurier dahulu'
                : 'Nombor penjejakan ${selected.name}',
            hintText: selected?.sample,
            helperText: selected?.hint,
            prefixIcon: const Icon(Icons.qr_code_2_rounded),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: selected == null ? null : () => _track(selected),
          icon: const Icon(Icons.local_shipping_rounded),
          label: const Text('Jejak parcel'),
          style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50)),
        ),
        if (recent.isNotEmpty) ...[
          const SectionHeader(title: 'Penghantaran terkini'),
          for (final s in recent) _RecentTile(shipment: s),
        ],
      ],
    );
  }
}

class _CourierChip extends StatelessWidget {
  final Courier courier;
  final bool selected;
  final VoidCallback onTap;
  const _CourierChip({
    required this.courier,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? courier.color : context.colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
          color: selected ? courier.color.withValues(alpha: 0.08) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: courier.color,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(courier.badge,
                  style: TextStyle(
                      color: courier.onColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ),
            const SizedBox(width: 8),
            Text(courier.name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            if (selected) ...[
              const SizedBox(width: 6),
              Icon(Icons.check_circle_rounded,
                  color: courier.color, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final Shipment shipment;
  const _RecentTile({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final c = shipment.courier;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: context.colors.surfaceContainerLow,
      child: ListTile(
        onTap: () => context.push('/courier/tracking', extra: shipment),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              color: c.color, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(c.badge,
              style: TextStyle(
                  color: c.onColor, fontWeight: FontWeight.w800)),
        ),
        title: Text(shipment.trackingNo,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${shipment.origin} → ${shipment.destination}',
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: shipment.status.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(shipment.status.label,
                  style: TextStyle(
                      color: shipment.status.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 2),
            Text(Formatters.relative(shipment.here.time),
                style: TextStyle(
                    fontSize: 11, color: context.colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
