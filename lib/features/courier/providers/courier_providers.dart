import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/courier_mock.dart';
import '../domain/courier_models.dart';

/// The courier chosen in the "Jejak" tab. Null until the user picks one — the
/// tracking-number field stays disabled while it is null.
class SelectedCourierNotifier extends Notifier<Courier?> {
  @override
  Courier? build() => null;

  void select(Courier c) => state = c;
  void clear() => state = null;
}

final selectedCourierProvider =
    NotifierProvider<SelectedCourierNotifier, Courier?>(
        SelectedCourierNotifier.new);

/// Shipments booked or tracked during this session, newest first.
class ShipmentsNotifier extends Notifier<List<Shipment>> {
  @override
  List<Shipment> build() => List.of(kRecentShipments);

  void add(Shipment s) {
    // De-duplicate by tracking number so re-tracking bumps it to the top.
    final rest = state.where((e) => e.trackingNo != s.trackingNo);
    state = [s, ...rest];
  }
}

final shipmentsProvider =
    NotifierProvider<ShipmentsNotifier, List<Shipment>>(ShipmentsNotifier.new);
