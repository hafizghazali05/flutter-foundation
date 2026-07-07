import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the user has finished the Getting Started flow. Kept in memory
/// (mock, like the rest of the template) so the splash can decide where to route
/// after the brand animation. Flip it with [OnboardingSeenNotifier.markSeen].
class OnboardingSeenNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void markSeen() => state = true;
}

final onboardingSeenProvider =
    NotifierProvider<OnboardingSeenNotifier, bool>(OnboardingSeenNotifier.new);
