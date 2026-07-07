import 'package:flutter/material.dart';

/// Which mailbox a message lives in.
enum EmailFolder { inbox, sent }

class EmailMessage {
  final String id;
  final String sender;
  final String senderEmail;
  final String subject;
  final String preview;
  final String body;
  final DateTime time;
  final bool read;
  final bool starred;
  final Color avatarColor;
  final List<String> labels;
  final EmailFolder folder;

  const EmailMessage({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.subject,
    required this.preview,
    required this.body,
    required this.time,
    this.read = false,
    this.starred = false,
    required this.avatarColor,
    this.labels = const [],
    this.folder = EmailFolder.inbox,
  });

  EmailMessage copyWith({bool? read, bool? starred, EmailFolder? folder}) {
    return EmailMessage(
      id: id,
      sender: sender,
      senderEmail: senderEmail,
      subject: subject,
      preview: preview,
      body: body,
      time: time,
      read: read ?? this.read,
      starred: starred ?? this.starred,
      avatarColor: avatarColor,
      labels: labels,
      folder: folder ?? this.folder,
    );
  }
}
