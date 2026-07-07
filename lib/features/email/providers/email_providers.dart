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
}

final emailProvider =
    NotifierProvider<EmailNotifier, List<EmailMessage>>(EmailNotifier.new);

final unreadEmailCountProvider = Provider<int>(
  (ref) => ref.watch(emailProvider).where((e) => !e.read).length,
);
