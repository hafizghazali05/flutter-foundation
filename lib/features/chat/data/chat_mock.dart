import 'package:flutter/material.dart';

import '../domain/chat_models.dart';

final DateTime _now = DateTime.now();

DateTime _ago({int m = 0, int h = 0, int d = 0}) =>
    _now.subtract(Duration(minutes: m, hours: h, days: d));

const _colors = [
  Color(0xFF6C4DF6),
  Color(0xFFEB5757),
  Color(0xFF17A67B),
  Color(0xFFF2994A),
  Color(0xFF2D9CDB),
];

final List<ChatThread> kMockThreads = [
  ChatThread(
    id: '1',
    name: 'Aisyah Rahman',
    avatarColor: _colors[0],
    lastMessage: 'Ok, jumpa esok ya 👋',
    time: _ago(m: 2),
    unread: 2,
    online: true,
  ),
  ChatThread(
    id: '2',
    name: 'Design Team',
    avatarColor: _colors[2],
    lastMessage: 'Farah: dah upload mockup baru',
    time: _ago(m: 24),
    unread: 5,
  ),
  ChatThread(
    id: '3',
    name: 'Imran Hakimi',
    avatarColor: _colors[1],
    lastMessage: 'Baik, nanti saya check invoice tu',
    time: _ago(h: 1),
    online: true,
  ),
  ChatThread(
    id: '4',
    name: 'Nadia',
    avatarColor: _colors[3],
    lastMessage: 'Terima kasih! 🙏',
    time: _ago(h: 3),
  ),
  ChatThread(
    id: '5',
    name: 'Support Bot',
    avatarColor: _colors[4],
    lastMessage: 'Your ticket #4821 has been resolved.',
    time: _ago(d: 1),
  ),
];

/// Seed conversations keyed by thread id.
Map<String, List<ChatMessage>> mockConversations() => {
      '1': [
        ChatMessage(id: '1a', text: 'Hai! Free tak esok?', time: _ago(m: 12), isMe: false),
        ChatMessage(id: '1b', text: 'Free, kul berapa?', time: _ago(m: 9), isMe: true),
        ChatMessage(id: '1c', text: 'Around 10 pagi kot', time: _ago(m: 6), isMe: false),
        ChatMessage(id: '1d', text: 'Ok set 👍', time: _ago(m: 4), isMe: true),
        ChatMessage(id: '1e', text: 'Ok, jumpa esok ya 👋', time: _ago(m: 2), isMe: false),
      ],
      '2': [
        ChatMessage(id: '2a', text: 'Team, status projek macam mana?', time: _ago(m: 40), isMe: true),
        ChatMessage(id: '2b', text: 'Farah: dah upload mockup baru', time: _ago(m: 24), isMe: false),
      ],
      '3': [
        ChatMessage(id: '3a', text: 'Invoice bulan ni dah keluar?', time: _ago(h: 2), isMe: true),
        ChatMessage(id: '3b', text: 'Baik, nanti saya check invoice tu', time: _ago(h: 1), isMe: false),
      ],
      '4': [
        ChatMessage(id: '4a', text: 'Dah settle semua 😄', time: _ago(h: 4), isMe: true),
        ChatMessage(id: '4b', text: 'Terima kasih! 🙏', time: _ago(h: 3), isMe: false),
      ],
      '5': [
        ChatMessage(id: '5a', text: 'Your ticket #4821 has been resolved.', time: _ago(d: 1), isMe: false),
      ],
    };
