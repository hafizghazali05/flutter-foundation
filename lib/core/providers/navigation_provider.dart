import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Selected bottom-nav tab index. Exposed so dashboard shortcuts can jump
/// between tabs (e.g. Home → Chat) without wiring a tab controller through.
class ShellIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void set(int index) => state = index;
}

final shellIndexProvider =
    NotifierProvider<ShellIndexNotifier, int>(ShellIndexNotifier.new);
