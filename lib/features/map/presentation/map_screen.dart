import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../data/map_mock.dart';
import '../domain/map_models.dart';
import '../providers/map_providers.dart';

/// OpenStreetMap-backed picker. The pin can be dragged & dropped, tapped onto a
/// spot, and the map can be filtered by category / search. All coordinate maths
/// go through [MapController.camera] so the pin stays glued to its geo-point as
/// the map pans and zooms.
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _map = MapController();
  final TextEditingController _search = TextEditingController();

  LatLng _pin = kKlCentre;
  bool _ready = false;
  bool _dragging = false;

  static const double _pinW = 46;
  static const double _pinH = 52;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _movePinTo(LatLng p) {
    setState(() => _pin = p);
  }

  void _recenter() {
    _map.move(_pin, _map.camera.zoom < 14 ? 15 : _map.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(filteredPlacesProvider);
    final filter = ref.watch(mapFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta — OpenStreetMap'),
        actions: [
          if (filter.isActive)
            IconButton(
              tooltip: 'Reset filter',
              icon: const Icon(Icons.filter_alt_off_rounded),
              onPressed: () {
                ref.read(mapFilterProvider.notifier).clear();
                _search.clear();
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: _pin,
              initialZoom: 14.5,
              minZoom: 3,
              maxZoom: 18,
              onMapReady: () => setState(() => _ready = true),
              // Keep the draggable pin glued to its geo-point while the map moves.
              onPositionChanged: (camera, hasGesture) {
                if (mounted) setState(() {});
              },
              onTap: (_, point) => _movePinTo(point),
              onLongPress: (_, point) => _movePinTo(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.livewebs.flutter_foundation',
                maxNativeZoom: 19,
              ),
              MarkerLayer(
                markers: [
                  for (final place in places)
                    Marker(
                      point: place.point,
                      width: 40,
                      height: 40,
                      child: _PlaceMarker(
                        place: place,
                        onTap: () => _openPlace(place),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Draggable pin overlay — only after the camera exists.
          if (_ready) _buildPin(),

          // Attribution required by the OSM tile usage policy.
          const Positioned(
            left: 8,
            bottom: 8,
            child: _Attribution(),
          ),

          // Search + category filters.
          _buildSearchBar(),

          // Selected-location panel.
          _buildBottomPanel(places),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 132),
        child: FloatingActionButton(
          heroTag: 'recenter',
          onPressed: _recenter,
          child: const Icon(Icons.my_location_rounded),
        ),
      ),
    );
  }

  Widget _buildPin() {
    final offset = _map.camera.latLngToScreenOffset(_pin);
    return Positioned(
      left: offset.dx - _pinW / 2,
      // Lift the whole pin a touch while dragging so it reads as "picked up".
      top: offset.dy - _pinH - (_dragging ? 10 : 0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) => setState(() => _dragging = true),
        onPanUpdate: (details) {
          final tip = _map.camera.latLngToScreenOffset(_pin) + details.delta;
          setState(() => _pin = _map.camera.screenOffsetToLatLng(tip));
        },
        onPanEnd: (_) {
          setState(() => _dragging = false);
          AppSnackbar.info(context, 'Pin dilepaskan di lokasi baru');
        },
        child: _PinWidget(dragging: _dragging, width: _pinW, height: _pinH),
      ),
    );
  }

  Widget _buildSearchBar() {
    final filter = ref.watch(mapFilterProvider);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  controller: _search,
                  onChanged: (v) =>
                      ref.read(mapFilterProvider.notifier).setQuery(v),
                  decoration: InputDecoration(
                    hintText: 'Cari tempat…',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () {
                              _search.clear();
                              ref.read(mapFilterProvider.notifier).setQuery('');
                            },
                          ),
                    filled: true,
                    fillColor: context.colors.surface,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final c in PlaceCategory.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          avatar: Icon(c.icon,
                              size: 18,
                              color: filter.categories.contains(c)
                                  ? Colors.white
                                  : c.color),
                          label: Text(c.label),
                          selected: filter.categories.contains(c),
                          showCheckmark: false,
                          selectedColor: c.color,
                          labelStyle: TextStyle(
                            color: filter.categories.contains(c)
                                ? Colors.white
                                : null,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          onSelected: (_) =>
                              ref.read(mapFilterProvider.notifier).toggle(c),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel(List<MapPlace> places) {
    // Nearest visible place to the pin, for a little context.
    MapPlace? nearest;
    double nearestM = double.infinity;
    for (final p in places) {
      final d = const Distance().as(LengthUnit.Meter, _pin, p.point);
      if (d < nearestM) {
        nearestM = d;
        nearest = p;
      }
    }

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(18),
        color: context.colors.surface,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.place_rounded, color: Color(0xFFEB5757)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lokasi pilihan',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(
                          '${_pin.latitude.toStringAsFixed(5)}, '
                          '${_pin.longitude.toStringAsFixed(5)}',
                          style: TextStyle(
                              fontSize: 12,
                              color: context.colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Text('${places.length} tempat',
                      style: TextStyle(
                          fontSize: 11,
                          color: context.colors.onSurfaceVariant)),
                ],
              ),
              if (nearest != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Berhampiran: ${nearest.name} • ${_distanceLabel(nearestM)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12, color: context.colors.onSurfaceVariant),
                ),
              ],
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => AppSnackbar.success(
                    context,
                    'Lokasi disimpan: '
                    '${_pin.latitude.toStringAsFixed(5)}, '
                    '${_pin.longitude.toStringAsFixed(5)}',
                  ),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Guna lokasi ini'),
                ),
              ),
              const SizedBox(height: 2),
              Text('Seret pin, ketik, atau tekan lama pada peta',
                  style: TextStyle(
                      fontSize: 11, color: context.colors.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }

  void _openPlace(MapPlace place) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: place.category.color,
                  child: Icon(place.category.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      Text(place.category.label,
                          style: TextStyle(
                              color: context.colors.onSurfaceVariant,
                              fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.star_rounded,
                    color: Color(0xFFF2C94C), size: 20),
                Text(place.rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18, color: context.colors.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(child: Text(place.address)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _movePinTo(place.point);
                  _map.move(place.point, 16);
                  AppSnackbar.info(context, 'Pin dipindah ke ${place.name}');
                },
                icon: const Icon(Icons.push_pin_rounded),
                label: const Text('Letak pin di sini'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _distanceLabel(double meters) {
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

/// The draggable pin. Grows a shadow + lifts while [dragging] for feedback.
class _PinWidget extends StatelessWidget {
  final bool dragging;
  final double width;
  final double height;
  const _PinWidget({
    required this.dragging,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height + 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 150),
            scale: dragging ? 1.15 : 1.0,
            child: Icon(
              Icons.location_on,
              size: height,
              color: const Color(0xFFEB5757),
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
          ),
          // Ground shadow — shrinks as the pin lifts.
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: dragging ? 6 : 12,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceMarker extends StatelessWidget {
  final MapPlace place;
  final VoidCallback onTap;
  const _PlaceMarker({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: place.category.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(place.category.icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '© OpenStreetMap',
        style: TextStyle(fontSize: 10, color: Colors.black87),
      ),
    );
  }
}
