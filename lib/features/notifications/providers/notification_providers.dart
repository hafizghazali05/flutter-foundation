import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notification_mock.dart';
import '../domain/notification_models.dart';

class NotificationNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() => List.of(kMockNotifications);

  void markRead(String id) {
    state = [
      for (final n in state) n.id == id ? n.copyWith(read: true) : n,
    ];
  }

  void markAllRead() {
    state = [for (final n in state) n.copyWith(read: true)];
  }

  void remove(String id) => state = [
        for (final n in state)
          if (n.id != id) n,
      ];

  void clearAll() => state = [];
}

final notificationsProvider =
    NotifierProvider<NotificationNotifier, List<AppNotification>>(
        NotificationNotifier.new);

final unreadNotificationCountProvider = Provider<int>(
  (ref) => ref.watch(notificationsProvider).where((n) => !n.read).length,
);
