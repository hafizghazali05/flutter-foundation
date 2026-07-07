import 'package:flutter/material.dart';

class ChatThread {
  final String id;
  final String name;
  final Color avatarColor;
  final String lastMessage;
  final DateTime time;
  final int unread;
  final bool online;

  const ChatThread({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.online = false,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final DateTime time;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
