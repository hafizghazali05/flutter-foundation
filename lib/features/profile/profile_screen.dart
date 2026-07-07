import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/utils/extensions.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../core/widgets/section_header.dart';
import 'providers/profile_provider.dart';

/// Profile screen with a switchable avatar: an animated Lottie or a photo the
/// user uploads from their gallery. Everything else (name, email) is pulled
/// from the mock [authProvider].
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            title: const Text('Profile'),
            flexibleSpace: FlexibleSpaceBar(
              background: _Header(name: auth.name, email: auth.email),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _StatsRow(),
                    const SectionHeader(title: 'Avatar'),
                    const _AvatarModeCard(),
                    const SectionHeader(title: 'About me'),
                    AppCard(
                      child: Text(
                        profile.bio,
                        style: TextStyle(
                          height: 1.4,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SectionHeader(title: 'Details'),
                    _InfoTile(
                      icon: Icons.alternate_email_rounded,
                      label: 'Email',
                      value: auth.email,
                    ),
                    _InfoTile(
                      icon: Icons.badge_outlined,
                      label: 'Username',
                      value: '@${auth.name.toLowerCase()}',
                    ),
                    _InfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: 'Kuala Lumpur, MY 🇲🇾',
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// Gradient header holding the switchable avatar and the user's name.
class _Header extends ConsumerWidget {
  final String name;
  final String email;
  const _Header({required this.name, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C4DF6), Color(0xFF9B51E0)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 48),
            const _Avatar(),
            const SizedBox(height: 14),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              email,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08),
      ),
    );
  }
}

/// The circular avatar. Shows a Lottie animation or the uploaded photo, with a
/// camera badge. Tapping it opens the gallery so you can upload straight away.
class _Avatar extends ConsumerWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    const size = 108.0;

    Widget inner;
    if (profile.mode == AvatarMode.photo && profile.hasPhoto) {
      inner = Image.memory(profile.photo!, fit: BoxFit.cover);
    } else if (profile.mode == AvatarMode.photo) {
      // Photo mode but nothing picked yet — invite an upload.
      inner = Container(
        color: Colors.white24,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 30),
            SizedBox(height: 4),
            Text('Upload',
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    } else {
      inner = ColoredBox(
        color: Colors.white,
        child: Lottie.asset(
          'assets/lottie/loader.json',
          fit: BoxFit.cover,
          repeat: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => pickProfilePhoto(context, ref),
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(child: inner),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card that lets you flip between the animated avatar and an uploaded photo.
class _AvatarModeCard extends ConsumerWidget {
  const _AvatarModeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<AvatarMode>(
            segments: const [
              ButtonSegment(
                value: AvatarMode.lottie,
                label: Text('Animated'),
                icon: Icon(Icons.auto_awesome_rounded),
              ),
              ButtonSegment(
                value: AvatarMode.photo,
                label: Text('Photo'),
                icon: Icon(Icons.image_outlined),
              ),
            ],
            selected: {profile.mode},
            onSelectionChanged: (s) => notifier.setMode(s.first),
          ),
          const SizedBox(height: 12),
          if (profile.mode == AvatarMode.photo) ...[
            FilledButton.icon(
              onPressed: () => pickProfilePhoto(context, ref),
              icon: const Icon(Icons.upload_rounded),
              label: Text(profile.hasPhoto ? 'Tukar gambar' : 'Upload gambar'),
            ),
            if (profile.hasPhoto) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  notifier.removePhoto();
                  AppSnackbar.info(context, 'Kembali ke avatar animasi');
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Buang gambar'),
              ),
            ],
          ] else
            Text(
              'Guna avatar Lottie animasi. Tekan "Photo" untuk upload gambar '
              'sendiri dari galeri.',
              style: TextStyle(
                  color: context.colors.onSurfaceVariant, fontSize: 13),
            ),
        ],
      ),
    );
  }
}

/// Opens the gallery, reads the chosen image as bytes, and stores it.
Future<void> pickProfilePhoto(BuildContext context, WidgetRef ref) async {
  try {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1000,
    );
    if (file == null) return; // user cancelled
    final bytes = await file.readAsBytes();
    ref.read(profileProvider.notifier).setPhoto(bytes);
    if (context.mounted) {
      AppSnackbar.success(context, 'Gambar profil dikemaskini ✓');
    }
  } catch (e) {
    if (context.mounted) {
      AppSnackbar.error(context, 'Tak dapat buka galeri — $e');
    }
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: const [
          Expanded(child: _Stat(value: '128', label: 'Posts')),
          Expanded(child: _Stat(value: '2.4k', label: 'Followers')),
          Expanded(child: _Stat(value: '312', label: 'Following')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: context.texts.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: context.colors.onSurfaceVariant, fontSize: 12)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: context.colors.primary.withValues(alpha: 0.12),
              child: Icon(icon, color: context.colors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: context.colors.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
