import '../domain/notification_models.dart';

final DateTime _now = DateTime.now();
DateTime _ago({int m = 0, int h = 0, int d = 0}) =>
    _now.subtract(Duration(minutes: m, hours: h, days: d));

final List<AppNotification> kMockNotifications = [
  AppNotification(
    id: 'n1',
    title: 'Parcel dalam perjalanan',
    body: 'Bungkusan J&T 630087654321 telah tiba di Hab Melaka.',
    time: _ago(m: 12),
    category: NotifCategory.delivery,
    route: '/courier',
  ),
  AppNotification(
    id: 'n2',
    title: 'Top up berjaya',
    body: 'RM 200.00 telah ditambah ke wallet anda melalui FPX.',
    time: _ago(m: 48),
    category: NotifCategory.payment,
    route: '/wallet',
  ),
  AppNotification(
    id: 'n3',
    title: 'Mesej baharu dari Aisyah',
    body: '"Boleh check design homepage tak?"',
    time: _ago(h: 2),
    category: NotifCategory.message,
  ),
  AppNotification(
    id: 'n4',
    title: 'Log masuk baharu dikesan',
    body: 'Peranti Windows di Kuala Lumpur log masuk ke akaun anda.',
    time: _ago(h: 5),
    category: NotifCategory.security,
    route: '/settings/2fa',
  ),
  AppNotification(
    id: 'n5',
    title: 'Diskaun 15% penghantaran',
    body: 'Guna kod SHIP15 untuk penghantaran Pos Laju hujung minggu ini.',
    time: _ago(h: 9),
    category: NotifCategory.promo,
    route: '/courier',
  ),
  AppNotification(
    id: 'n6',
    title: 'Pengeluaran diproses',
    body: 'RM 300.00 dihantar ke Maybank •••• 8842.',
    time: _ago(d: 1),
    category: NotifCategory.payment,
    read: true,
    route: '/wallet',
  ),
  AppNotification(
    id: 'n7',
    title: 'Kemas kini Flutter 3.44',
    body: 'Impeller kini default, Material 3 carousel & DevTools lebih laju.',
    time: _ago(d: 2),
    category: NotifCategory.system,
    read: true,
  ),
];
