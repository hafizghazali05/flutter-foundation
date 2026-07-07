import 'package:flutter/material.dart';

/// Notification category — drives the leading icon + accent colour.
enum NotifCategory {
  payment(Icons.payments_rounded, 'Pembayaran', Color(0xFF635BFF)),
  delivery(Icons.local_shipping_rounded, 'Penghantaran', Color(0xFFF2994A)),
  message(Icons.chat_bubble_rounded, 'Mesej', Color(0xFF6C4DF6)),
  security(Icons.shield_rounded, 'Keselamatan', Color(0xFF2D9CDB)),
  promo(Icons.local_offer_rounded, 'Promosi', Color(0xFFEB5757)),
  system(Icons.info_rounded, 'Sistem', Color(0xFF17A67B));

  final IconData icon;
  final String label;
  final Color color;
  const NotifCategory(this.icon, this.label, this.color);
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final NotifCategory category;
  final bool read;

  /// Optional in-app route to open when tapped (e.g. `/wallet`).
  final String? route;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.category,
    this.read = false,
    this.route,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        time: time,
        category: category,
        read: read ?? this.read,
        route: route,
      );
}
