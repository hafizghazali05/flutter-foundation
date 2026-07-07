import 'package:flutter/material.dart';

import '../domain/email_models.dart';

final DateTime _now = DateTime.now();
DateTime _ago({int m = 0, int h = 0, int d = 0}) =>
    _now.subtract(Duration(minutes: m, hours: h, days: d));

final List<EmailMessage> kMockEmails = [
  EmailMessage(
    id: '1',
    sender: 'GitHub',
    senderEmail: 'noreply@github.com',
    subject: '[flutter-foundation] CI passed ✓',
    preview: 'Your workflow run "build" completed successfully on main.',
    body:
        'Hi Hafiz,\n\nYour workflow run "build" completed successfully on branch main.\n\nDuration: 2m 41s\nAll 128 tests passed.\n\n— GitHub Actions',
    time: _ago(m: 8),
    avatarColor: const Color(0xFF24292E),
    labels: ['CI', 'Inbox'],
  ),
  EmailMessage(
    id: '2',
    sender: 'Aisyah Rahman',
    senderEmail: 'aisyah@studio.co',
    subject: 'Revisi design untuk homepage',
    preview: 'Hai Hafiz, saya dah update spacing dan color token…',
    body:
        'Hai Hafiz,\n\nSaya dah update spacing dan color token untuk homepage ikut feedback semalam. Boleh check dan bagi tau kalau ok?\n\nTerima kasih,\nAisyah',
    time: _ago(m: 46),
    starred: true,
    avatarColor: const Color(0xFF6C4DF6),
    labels: ['Work'],
  ),
  EmailMessage(
    id: '3',
    sender: 'Stripe',
    senderEmail: 'receipts@stripe.com',
    subject: 'Your receipt from Livewebs (RM 149.00)',
    preview: 'Payment received. Invoice #LW-2043 is attached.',
    body:
        'Payment received.\n\nAmount: RM 149.00\nInvoice: #LW-2043\nCard: •••• 4242\n\nThank you for your business.',
    time: _ago(h: 3),
    read: true,
    avatarColor: const Color(0xFF635BFF),
    labels: ['Receipts'],
  ),
  EmailMessage(
    id: '4',
    sender: 'Nadia',
    senderEmail: 'nadia@livewebs.my',
    subject: 'Lunch meeting Jumaat?',
    preview: 'Boleh set 12:30 tak? Ada nak bincang pasal Q3.',
    body:
        'Hai,\n\nBoleh set lunch meeting Jumaat 12:30 tak? Ada nak bincang pasal roadmap Q3.\n\nNadia',
    time: _ago(h: 6),
    avatarColor: const Color(0xFFF2994A),
    labels: ['Work'],
  ),
  EmailMessage(
    id: '5',
    sender: 'Flutter Weekly',
    senderEmail: 'hello@flutterweekly.net',
    subject: 'Issue #412 — what\'s new in Flutter 3.44',
    preview: 'Impeller everywhere, Material 3 carousel, DevTools upgrades…',
    body:
        'This week:\n\n• Impeller is now default on more platforms\n• New Material 3 Carousel widget\n• DevTools performance upgrades\n• Riverpod 3 deep-dive\n\nHappy coding!',
    time: _ago(d: 1),
    read: true,
    avatarColor: const Color(0xFF17A67B),
    labels: ['Newsletter'],
  ),
];
