import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock authenticated user. Starts logged-in so the app opens straight into the
/// shell; logout flips [isLoggedIn] and navigation sends the user to /login.
class AuthState {
  final bool isLoggedIn;
  final String name;
  final String email;

  const AuthState({
    required this.isLoggedIn,
    required this.name,
    required this.email,
  });

  AuthState copyWith({bool? isLoggedIn, String? name, String? email}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState(
        isLoggedIn: true,
        name: 'Hafiz',
        email: 'hafiz@livewebs.my',
      );

  void login({String name = 'Hafiz', required String email}) {
    state = state.copyWith(isLoggedIn: true, name: name, email: email);
  }

  void logout() => state = state.copyWith(isLoggedIn: false);
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
