import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/section_header.dart';
import '../domain/courier_models.dart';
import 'widgets/rail_timeline.dart';

/// Full tracking view: status header, a live route map, and the railway-style
/// point-to-point timeline.
class TrackingScreen extends StatelessWidget {
  final Shipment shipment;
  const TrackingScreen({super.key, required this.shipment});

  @override
  Widget build(BuildContext context) {
    final c = shipment.courier;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            Text(shipment.trackingNo,
                style: TextStyle(
                    fontSize: 12, color: context.colors.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Salin nombor',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () async {
              await Clipboard.setData(
                  ClipboardData(text: shipment.trackingNo));
              if (context.mounted) {
                AppSnackbar.success(context, 'Nombor penjejakan disalin');
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          _StatusCard(shipment: shipment),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 260,
              child: _RouteMap(shipment: shipment),
            ),
          ),
          const SectionHeader(title: 'Perjalanan bungkusan (point-to-point)'),
          RailTimeline(checkpoints: shipment.checkpoints),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final Shipment shipment;
  const _StatusCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final c = shipment.courier;
    final status = shipment.status;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: context.colors.surfaceContainerLow,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: c.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(c.badge,
                    style: TextStyle(
                        color: c.onColor, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('Anggaran tiba: ${Formatters.date(shipment.eta)}',
                        style: TextStyle(
                            fontSize: 12,
                            color: context.colors.onSurfaceVariant)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(status.label,
                    style: TextStyle(
                        color: status.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: shipment.progress,
              minHeight: 7,
              backgroundColor: context.colors.surfaceContainerHighest,
              color: status.color,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.trip_origin_rounded,
                  size: 16, color: Color(0xFF1F8A50)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(shipment.origin,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.arrow_forward_rounded,
                  size: 16, color: context.colors.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(shipment.destination,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.location_on_rounded,
                  size: 16, color: Color(0xFFC0392B)),
            ],
          ),
        ],
      ),
    );
  }
}

/// The route map: the full rail line in grey, the travelled portion in green,
/// station dots, and a pulsing "train" marker at the current position.
class _RouteMap extends StatelessWidget {
  final Shipment shipment;
  const _RouteMap({required this.shipment});

  @override
  Widget build(BuildContext context) {
    final here = shipment.here.point;
    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints(shipment.route),
          padding: const EdgeInsets.all(44),
          maxZoom: 12,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.livewebs.flutter_foundation',
          maxNativeZoom: 19,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: shipment.route,
              color: const Color(0xFFBDBDBD),
              strokeWidth: 4,
            ),
            Polyline(
              points: shipment.travelled,
              color: const Color(0xFF1F8A50),
              strokeWidth: 5,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            for (final cp in shipment.checkpoints)
              if (!cp.current)
                Marker(
                  point: cp.point,
                  width: 16,
                  height: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cp.done
                          ? const Color(0xFF1F8A50)
                          : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: cp.done
                              ? const Color(0xFF1F8A50)
                              : const Color(0xFFBDBDBD),
                          width: 3),
                    ),
                  ),
                ),
            Marker(
              point: here,
              width: 44,
              height: 44,
              child: _TrainMarker(color: context.colors.primary),
            ),
          ],
        ),
        const Positioned(
          left: 6,
          bottom: 4,
          child: Text('© OpenStreetMap',
              style: TextStyle(fontSize: 9, color: Colors.black54)),
        ),
      ],
    );
  }
}

class _TrainMarker extends StatelessWidget {
  final Color color;
  const _TrainMarker({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 1),
        ],
      ),
      child: const Icon(Icons.local_shipping_rounded,
          color: Colors.white, size: 22),
    );
  }
}
