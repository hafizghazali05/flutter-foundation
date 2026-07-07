import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// A courier service. [hint] + [sample] drive the tracking-number placeholder
/// so the field adapts to whichever courier is picked.
class Courier {
  final String id;
  final String name;
  final Color color;

  /// Human hint shown under the field, e.g. "12 digit nombor".
  final String hint;

  /// A realistic example tracking number for the placeholder.
  final String sample;

  const Courier({
    required this.id,
    required this.name,
    required this.color,
    required this.hint,
    required this.sample,
  });

  /// Two-letter badge used for the logo chip.
  String get badge {
    final clean = name.replaceAll('&', '').trim();
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// White text is unreadable on light-yellow brands — pick by luminance.
  Color get onColor =>
      color.computeLuminance() > 0.6 ? Colors.black87 : Colors.white;
}

/// High-level state of a shipment. Ordered from booked → delivered.
enum ShipmentStatus {
  booked('Ditempah', Color(0xFF9B51E0)),
  picked('Bungkusan diambil', Color(0xFF2D9CDB)),
  inTransit('Dalam transit', Color(0xFFF2994A)),
  outForDelivery('Untuk penghantaran', Color(0xFF17A67B)),
  delivered('Telah dihantar', Color(0xFF1F8A50)),
  exception('Ada isu', Color(0xFFC0392B));

  final String label;
  final Color color;
  const ShipmentStatus(this.label, this.color);
}

/// One "station" on the parcel's rail line (point-to-point tracking).
class TrackCheckpoint {
  final String station;
  final String city;
  final String note;
  final DateTime time;
  final bool done;
  final bool current;
  final LatLng point;

  const TrackCheckpoint({
    required this.station,
    required this.city,
    required this.note,
    required this.time,
    required this.done,
    required this.current,
    required this.point,
  });
}

class Shipment {
  final String trackingNo;
  final Courier courier;
  final String origin;
  final String destination;
  final ShipmentStatus status;
  final List<TrackCheckpoint> checkpoints;
  final DateTime eta;

  const Shipment({
    required this.trackingNo,
    required this.courier,
    required this.origin,
    required this.destination,
    required this.status,
    required this.checkpoints,
    required this.eta,
  });

  List<LatLng> get route => [for (final c in checkpoints) c.point];

  LatLng get originPoint => checkpoints.first.point;
  LatLng get destPoint => checkpoints.last.point;

  /// Where the parcel is right now — the current station, or the last one
  /// reached if everything is already done (delivered).
  TrackCheckpoint get here => checkpoints.firstWhere(
        (c) => c.current,
        orElse: () => checkpoints.lastWhere((c) => c.done,
            orElse: () => checkpoints.first),
      );

  /// Points already travelled — used to draw the "completed" rail segment.
  List<LatLng> get travelled {
    final points = <LatLng>[];
    for (final c in checkpoints) {
      points.add(c.point);
      if (c.current) break;
    }
    return points;
  }

  double get progress {
    final doneCount = checkpoints.where((c) => c.done || c.current).length;
    return doneCount / checkpoints.length;
  }
}
