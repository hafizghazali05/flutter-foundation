import 'package:latlong2/latlong.dart';

import '../domain/courier_models.dart';
import 'courier_data.dart';

/// A single stop on a rail-style delivery route.
class _Station {
  final String name;
  final String city;
  final LatLng point;
  const _Station(this.name, this.city, this.point);
}

class _Route {
  final String origin;
  final String destination;
  final List<_Station> stations;
  const _Route(this.origin, this.destination, this.stations);
}

/// Point-to-point routes across Peninsular Malaysia. The parcel travels these
/// like a train down a rail line, hub by hub.
const List<_Route> _routes = [
  _Route('Kuala Lumpur', 'Pulau Pinang', [
    _Station('Pusat Penghantaran KL', 'Kuala Lumpur', LatLng(3.1390, 101.6869)),
    _Station('Hab Pengisihan Shah Alam', 'Shah Alam', LatLng(3.0733, 101.5185)),
    _Station('Hab Transit Ipoh', 'Ipoh', LatLng(4.5975, 101.0901)),
    _Station('Hab Butterworth', 'Butterworth', LatLng(5.3991, 100.3638)),
    _Station('Pusat Serahan Georgetown', 'Georgetown', LatLng(5.4141, 100.3288)),
  ]),
  _Route('Kuala Lumpur', 'Johor Bahru', [
    _Station('Pusat Penghantaran KL', 'Kuala Lumpur', LatLng(3.1390, 101.6869)),
    _Station('Hab Seremban', 'Seremban', LatLng(2.7258, 101.9424)),
    _Station('Hab Melaka', 'Melaka', LatLng(2.1896, 102.2501)),
    _Station('Hab Muar', 'Muar', LatLng(2.0442, 102.5689)),
    _Station('Pusat Serahan Johor Bahru', 'Johor Bahru', LatLng(1.4927, 103.7414)),
  ]),
  _Route('Kuala Lumpur', 'Kuantan', [
    _Station('Pusat Penghantaran KL', 'Kuala Lumpur', LatLng(3.1390, 101.6869)),
    _Station('Hab Bentong', 'Bentong', LatLng(3.5222, 101.9089)),
    _Station('Hab Temerloh', 'Temerloh', LatLng(3.4499, 102.4179)),
    _Station('Pusat Serahan Kuantan', 'Kuantan', LatLng(3.8077, 103.3260)),
  ]),
  _Route('Petaling Jaya', 'Kota Bharu', [
    _Station('Pusat Penghantaran PJ', 'Petaling Jaya', LatLng(3.1073, 101.6067)),
    _Station('Hab Gua Musang', 'Gua Musang', LatLng(4.8829, 101.9660)),
    _Station('Hab Kuala Krai', 'Kuala Krai', LatLng(5.5305, 102.1997)),
    _Station('Pusat Serahan Kota Bharu', 'Kota Bharu', LatLng(6.1254, 102.2381)),
  ]),
];

String _noteFor(int i, int last) {
  if (i == 0) return 'Bungkusan diterima & diproses';
  if (i == last) return 'Penghantaran ke alamat penerima';
  return 'Pengisihan & pemunggahan di hab';
}

/// Builds a deterministic shipment for [trackingNo] so the same number always
/// resolves to the same route + progress. Pass [atStation] to force a starting
/// point (e.g. 0 for a freshly booked parcel). Real integrations would hit the
/// courier's tracking API here instead.
Shipment buildShipment(Courier courier, String trackingNo, {int? atStation}) {
  final seed = trackingNo.hashCode.abs();
  final route = _routes[seed % _routes.length];
  final n = route.stations.length;

  // Current station index. Booked parcels sit at 0; otherwise 1..n-1.
  final current =
      (atStation ?? (1 + (seed ~/ 7) % (n - 1))).clamp(0, n - 1);

  // Anchor the current checkpoint at roughly "now"; ~11h between hubs.
  const gap = Duration(hours: 11);
  final start = DateTime.now().subtract(gap * current);

  final checkpoints = <TrackCheckpoint>[
    for (var i = 0; i < n; i++)
      TrackCheckpoint(
        station: route.stations[i].name,
        city: route.stations[i].city,
        note: _noteFor(i, n - 1),
        time: start.add(gap * i),
        done: i < current,
        current: i == current,
        point: route.stations[i].point,
      ),
  ];

  final ShipmentStatus status;
  if (current <= 0) {
    status = ShipmentStatus.booked;
  } else if (current >= n - 1) {
    status = ShipmentStatus.delivered;
  } else if (current == n - 2) {
    status = ShipmentStatus.outForDelivery;
  } else if (current == 1) {
    status = ShipmentStatus.picked;
  } else {
    status = ShipmentStatus.inTransit;
  }

  return Shipment(
    trackingNo: trackingNo,
    courier: courier,
    origin: route.origin,
    destination: route.destination,
    status: status,
    checkpoints: checkpoints,
    eta: checkpoints.last.time,
  );
}

/// A couple of pre-built shipments for the "Penghantaran terkini" list.
final List<Shipment> kRecentShipments = [
  buildShipment(courierById('jnt'), '630087654321'),
  buildShipment(courierById('poslaju'), 'ELM739284756MY'),
  buildShipment(courierById('ninjavan'), 'NVMY00123456789'),
];
