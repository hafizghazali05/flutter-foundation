import 'package:latlong2/latlong.dart';

import '../domain/map_models.dart';

/// Default map centre — KLCC, Kuala Lumpur.
const LatLng kKlCentre = LatLng(3.1570, 101.7123);

/// A handful of real-ish landmarks around central KL used to demo the marker
/// layer + category filtering. Coordinates are approximate.
const List<MapPlace> kMapPlaces = [
  MapPlace(
    id: 'p1',
    name: 'Suria KLCC',
    address: 'Jalan Ampang, Kuala Lumpur',
    category: PlaceCategory.shopping,
    point: LatLng(3.1579, 101.7116),
    rating: 4.7,
  ),
  MapPlace(
    id: 'p2',
    name: 'Pavilion Kuala Lumpur',
    address: 'Jalan Bukit Bintang, KL',
    category: PlaceCategory.shopping,
    point: LatLng(3.1490, 101.7130),
    rating: 4.6,
  ),
  MapPlace(
    id: 'p3',
    name: 'Lot 10 Shopping Centre',
    address: 'Jalan Sultan Ismail, KL',
    category: PlaceCategory.shopping,
    point: LatLng(3.1465, 101.7106),
    rating: 4.3,
  ),
  MapPlace(
    id: 'p4',
    name: 'Nasi Kandar Pelita',
    address: 'Jalan Ampang, KL',
    category: PlaceCategory.food,
    point: LatLng(3.1607, 101.7237),
    rating: 4.1,
  ),
  MapPlace(
    id: 'p5',
    name: 'Restoran Yut Kee',
    address: 'Jalan Kamunting, KL',
    category: PlaceCategory.food,
    point: LatLng(3.1607, 101.6996),
    rating: 4.5,
  ),
  MapPlace(
    id: 'p6',
    name: 'VCR Cafe',
    address: 'Jalan Galloway, KL',
    category: PlaceCategory.cafe,
    point: LatLng(3.1418, 101.7028),
    rating: 4.6,
  ),
  MapPlace(
    id: 'p7',
    name: 'Maybank Tower',
    address: 'Jalan Tun Perak, KL',
    category: PlaceCategory.bank,
    point: LatLng(3.1479, 101.6987),
    rating: 4.0,
  ),
  MapPlace(
    id: 'p8',
    name: 'CIMB Bank Bukit Bintang',
    address: 'Jalan Bukit Bintang, KL',
    category: PlaceCategory.bank,
    point: LatLng(3.1470, 101.7118),
    rating: 3.9,
  ),
  MapPlace(
    id: 'p9',
    name: 'Petronas Jalan Tun Razak',
    address: 'Jalan Tun Razak, KL',
    category: PlaceCategory.petrol,
    point: LatLng(3.1652, 101.7160),
    rating: 4.2,
  ),
  MapPlace(
    id: 'p10',
    name: 'Shell Jalan Sultan Ismail',
    address: 'Jalan Sultan Ismail, KL',
    category: PlaceCategory.petrol,
    point: LatLng(3.1560, 101.7060),
    rating: 4.0,
  ),
  MapPlace(
    id: 'p11',
    name: 'Hospital Kuala Lumpur',
    address: 'Jalan Pahang, KL',
    category: PlaceCategory.hospital,
    point: LatLng(3.1725, 101.7011),
    rating: 4.1,
  ),
  MapPlace(
    id: 'p12',
    name: 'Gleneagles Hospital KL',
    address: 'Jalan Ampang, KL',
    category: PlaceCategory.hospital,
    point: LatLng(3.1615, 101.7295),
    rating: 4.4,
  ),
  MapPlace(
    id: 'p13',
    name: 'Masjid Jamek',
    address: 'Jalan Tun Perak, KL',
    category: PlaceCategory.mosque,
    point: LatLng(3.1489, 101.6955),
    rating: 4.7,
  ),
  MapPlace(
    id: 'p14',
    name: 'Masjid Negara',
    address: 'Jalan Perdana, KL',
    category: PlaceCategory.mosque,
    point: LatLng(3.1416, 101.6919),
    rating: 4.8,
  ),
  MapPlace(
    id: 'p15',
    name: 'Grand Hyatt Kuala Lumpur',
    address: 'Jalan Pinang, KL',
    category: PlaceCategory.hotel,
    point: LatLng(3.1533, 101.7132),
    rating: 4.6,
  ),
  MapPlace(
    id: 'p16',
    name: 'The Ritz-Carlton, KL',
    address: 'Jalan Imbi, KL',
    category: PlaceCategory.hotel,
    point: LatLng(3.1470, 101.7160),
    rating: 4.7,
  ),
];
