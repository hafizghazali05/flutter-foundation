import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// A category a place can belong to. Each carries its own icon + accent colour
/// so the filter chips and map markers stay visually consistent.
enum PlaceCategory {
  food(Icons.restaurant_rounded, 'Makanan', Color(0xFFEB5757)),
  cafe(Icons.local_cafe_rounded, 'Kafe', Color(0xFF8D6E63)),
  bank(Icons.local_atm_rounded, 'ATM / Bank', Color(0xFF17A67B)),
  petrol(Icons.local_gas_station_rounded, 'Stesen Minyak', Color(0xFF2D9CDB)),
  hospital(Icons.local_hospital_rounded, 'Hospital', Color(0xFFC0392B)),
  mosque(Icons.mosque_rounded, 'Masjid', Color(0xFF1F8A50)),
  hotel(Icons.hotel_rounded, 'Hotel', Color(0xFF9B51E0)),
  shopping(Icons.shopping_bag_rounded, 'Beli-belah', Color(0xFFF2994A));

  final IconData icon;
  final String label;
  final Color color;
  const PlaceCategory(this.icon, this.label, this.color);
}

/// A point of interest rendered as a marker on the map.
class MapPlace {
  final String id;
  final String name;
  final String address;
  final PlaceCategory category;
  final LatLng point;
  final double rating;

  const MapPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.category,
    required this.point,
    required this.rating,
  });
}
