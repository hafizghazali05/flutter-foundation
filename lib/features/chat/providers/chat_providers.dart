import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/chat_mock.dart';
import '../domain/chat_models.dart';

final chatThreadsProvider =
    Provider<List<ChatThread>>((ref) => kMockThreads);

ChatThread threadById(String id) =>
    kMockThreads.firstWhere((t) => t.id == id);

/// All conversations, keyed by thread id. Sending a message appends to the
/// matching list immutably so the UI rebuilds.
class ChatNotifier extends Notifier<Map<String, List<ChatMessage>>> {
  @override
  Map<String, List<ChatMessage>> build() => mockConversations();

  void send(String threadId, String text) {
    final current = state[threadId] ?? const [];
    final message = ChatMessage(
      id: 'm${current.length + 1}',
      text: text,
      time: DateTime.now(),
      isMe: true,
    );
    state = {
      ...state,
      threadId: [...current, message],
    };
  }
}

final chatProvider =
    NotifierProvider<ChatNotifier, Map<String, List<ChatMessage>>>(
        ChatNotifier.new);
