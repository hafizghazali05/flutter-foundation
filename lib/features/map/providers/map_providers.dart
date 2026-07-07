import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/map_mock.dart';
import '../domain/map_models.dart';

/// Search text + selected categories. An empty [categories] set means "show
/// everything" so the map is not blank before the user picks a filter.
class MapFilter {
  final String query;
  final Set<PlaceCategory> categories;

  const MapFilter({this.query = '', this.categories = const {}});

  MapFilter copyWith({String? query, Set<PlaceCategory>? categories}) {
    return MapFilter(
      query: query ?? this.query,
      categories: categories ?? this.categories,
    );
  }

  bool get isActive => query.isNotEmpty || categories.isNotEmpty;
}

class MapFilterNotifier extends Notifier<MapFilter> {
  @override
  MapFilter build() => const MapFilter();

  void setQuery(String q) => state = state.copyWith(query: q);

  void toggle(PlaceCategory c) {
    final next = {...state.categories};
    if (!next.add(c)) next.remove(c);
    state = state.copyWith(categories: next);
  }

  void clear() => state = const MapFilter();
}

final mapFilterProvider =
    NotifierProvider<MapFilterNotifier, MapFilter>(MapFilterNotifier.new);

/// The places that survive the current search + category filter.
final filteredPlacesProvider = Provider<List<MapPlace>>((ref) {
  final f = ref.watch(mapFilterProvider);
  final q = f.query.trim().toLowerCase();
  return kMapPlaces.where((p) {
    final matchesQuery = q.isEmpty ||
        p.name.toLowerCase().contains(q) ||
        p.address.toLowerCase().contains(q);
    final matchesCategory =
        f.categories.isEmpty || f.categories.contains(p.category);
    return matchesQuery && matchesCategory;
  }).toList();
});
