import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How the profile avatar is rendered.
///
/// [lottie] shows a bundled animated avatar; [photo] shows an image the user
/// picked from their gallery. The profile screen lets you flip between them.
enum AvatarMode { lottie, photo }

class ProfileState {
  final AvatarMode mode;

  /// Raw bytes of the uploaded photo. Kept as bytes (not a path) so it works
  /// the same on web, desktop and mobile. Null until the user picks one.
  final Uint8List? photo;
  final String bio;

  const ProfileState({
    this.mode = AvatarMode.lottie,
    this.photo,
    this.bio = 'Flutter developer • building delightful mobile apps 🚀',
  });

  bool get hasPhoto => photo != null;

  ProfileState copyWith({
    AvatarMode? mode,
    Uint8List? photo,
    bool clearPhoto = false,
    String? bio,
  }) {
    return ProfileState(
      mode: mode ?? this.mode,
      photo: clearPhoto ? null : (photo ?? this.photo),
      bio: bio ?? this.bio,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  void setMode(AvatarMode mode) => state = state.copyWith(mode: mode);

  /// Store a freshly picked image and switch to photo mode.
  void setPhoto(Uint8List bytes) =>
      state = state.copyWith(photo: bytes, mode: AvatarMode.photo);

  /// Drop the uploaded photo and fall back to the animated avatar.
  void removePhoto() =>
      state = state.copyWith(clearPhoto: true, mode: AvatarMode.lottie);

  void setBio(String bio) => state = state.copyWith(bio: bio);
}

final profileProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);
