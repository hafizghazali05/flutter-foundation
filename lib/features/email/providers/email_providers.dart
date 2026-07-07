import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/email_mock.dart';
import '../domain/email_models.dart';

class EmailNotifier extends Notifier<List<EmailMessage>> {
  @override
  List<EmailMessage> build() => List.of(kMockEmails);

  EmailMessage? byId(String id) {
    for (final e in state) {
      if (e.id == id) return e;
    }
    return null;
  }

  void _update(String id, EmailMessage Function(EmailMessage) transform) {
    state = [
      for (final e in state) e.id == id ? transform(e) : e,
    ];
  }

  void markRead(String id) => _update(id, (e) => e.copyWith(read: true));

  void toggleStar(String id) =>
      _update(id, (e) => e.copyWith(starred: !e.starred));

  void delete(String id) =>
      state = [for (final e in state) if (e.id != id) e];

  /// Composes a message and drops it into the Sent folder.
  void sendEmail({
    required String to,
    required String subject,
    required String body,
  }) {
    final local = to.contains('@') ? to.split('@').first : to;
    final message = EmailMessage(
      id: 's${DateTime.now().microsecondsSinceEpoch}',
      sender: local.isEmpty ? to : local,
      senderEmail: to,
      subject: subject.trim().isEmpty ? '(tiada subjek)' : subject.trim(),
      preview: body.trim().isEmpty
          ? 'Tiada kandungan'
          : body.trim().replaceAll('\n', ' '),
      body: body,
      time: DateTime.now(),
      read: true,
      avatarColor: const Color(0xFF6C4DF6),
      labels: const ['Sent'],
      folder: EmailFolder.sent,
    );
    state = [message, ...state];
  }
}

final emailProvider =
    NotifierProvider<EmailNotifier, List<EmailMessage>>(EmailNotifier.new);

/// Currently selected mailbox folder in the inbox screen.
class EmailFolderNotifier extends Notifier<EmailFolder> {
  @override
  EmailFolder build() => EmailFolder.inbox;
  void set(EmailFolder folder) => state = folder;
}

final emailFolderProvider =
    NotifierProvider<EmailFolderNotifier, EmailFolder>(EmailFolderNotifier.new);

/// Unread count for the Inbox folder only (drives the bottom-nav badge).
final unreadEmailCountProvider = Provider<int>(
  (ref) => ref
      .watch(emailProvider)
      .where((e) => e.folder == EmailFolder.inbox && !e.read)
      .length,
);
