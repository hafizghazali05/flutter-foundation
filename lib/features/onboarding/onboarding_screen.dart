import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/onboarding_provider.dart';

/// Getting Started flow — a swipeable, next-next-finish walkthrough shown on the
/// first launch. Skippable, with animated page dots and a brand-matched
/// illustration per page.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pages = <_OnbPage>[
    _OnbPage(
      icon: Icons.dashboard_customize_rounded,
      accents: [Icons.chat_bubble_rounded, Icons.mail_rounded,
          Icons.account_balance_wallet_rounded],
      title: 'Satu asas, banyak modul',
      body: 'Chat, Email, Wallet, Kurier, Peta & Carta — semua siap pakai '
          'dalam satu template yang kemas.',
      color: Color(0xFF6C4DF6),
    ),
    _OnbPage(
      icon: Icons.palette_rounded,
      accents: [Icons.dark_mode_rounded, Icons.text_fields_rounded,
          Icons.auto_awesome_rounded],
      title: 'Reka bentuk Material 3',
      body: 'Tema gelap & terang, tipografi Poppins dan animasi halus — '
          'konsisten merentas setiap skrin.',
      color: Color(0xFF17A67B),
    ),
    _OnbPage(
      icon: Icons.bolt_rounded,
      accents: [Icons.route_rounded, Icons.layers_rounded, Icons.speed_rounded],
      title: 'Pantas & moden',
      body: 'Dibina atas Riverpod 3, go_router dan Impeller. Seni bina bersih '
          'yang mudah diselenggara.',
      color: Color(0xFFF2994A),
    ),
    _OnbPage(
      icon: Icons.rocket_launch_rounded,
      accents: [Icons.bolt_rounded, Icons.cloud_done_rounded, Icons.check_rounded],
      title: 'Sedia untuk projek anda',
      body: 'Salin modul, ganti data mock dengan API sebenar, dan terus hantar '
          'ke pelanggan anda.',
      color: Color(0xFF2D9CDB),
    ),
  ];

  bool get _isLast => _page == _pages.length - 1;

  void _finish() {
    ref.read(onboardingSeenProvider.notifier).markSeen();
    context.go('/');
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = _pages[_page].color;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip — hidden on the last page where the primary CTA takes over.
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  opacity: _isLast ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: TextButton(
                    onPressed: _isLast ? null : _finish,
                    child: const Text('Langkau'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _OnbPageView(page: _pages[i]),
              ),
            ),
            // Animated dots.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _pages.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: i == _page ? 26 : 8,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? accent
                          : scheme.onSurfaceVariant.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  style: FilledButton.styleFrom(backgroundColor: accent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_isLast ? 'Mula sekarang' : 'Seterusnya'),
                      const SizedBox(width: 8),
                      Icon(_isLast
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnbPage {
  final IconData icon;
  final List<IconData> accents;
  final String title;
  final String body;
  final Color color;

  const _OnbPage({
    required this.icon,
    required this.accents,
    required this.title,
    required this.body,
    required this.color,
  });
}

class _OnbPageView extends StatelessWidget {
  final _OnbPage page;
  const _OnbPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Illustration(page: page),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
          const SizedBox(height: 12),
          Text(
            page.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  final _OnbPage page;
  const _Illustration({required this.page});

  @override
  Widget build(BuildContext context) {
    final c = page.color;
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft halo.
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.withValues(alpha: 0.08),
            ),
          ),
          // Main gradient card.
          Container(
            width: 138,
            height: 138,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c, Color.lerp(c, Colors.black, 0.18)!],
              ),
              boxShadow: [
                BoxShadow(
                  color: c.withValues(alpha: 0.4),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(page.icon, size: 62, color: Colors.white),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -6, end: 6, duration: 2200.ms, curve: Curves.easeInOut),
          // Floating accent chips around the card.
          _chip(page.accents[0], c, const Alignment(-1.05, -0.75), 0),
          _chip(page.accents[1], c, const Alignment(1.08, -0.15), 250),
          _chip(page.accents[2], c, const Alignment(-0.75, 0.95), 500),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, Color c, Alignment align, int delayMs) {
    return Align(
      alignment: align,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: c.withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: c),
      )
          .animate()
          .fadeIn(delay: (300 + delayMs).ms, duration: 400.ms)
          .scale(begin: const Offset(0.4, 0.4), curve: Curves.easeOutBack)
          .then()
          .animate(onPlay: (ctrl) => ctrl.repeat(reverse: true))
          .moveY(begin: -4, end: 4, duration: (1800 + delayMs).ms,
              curve: Curves.easeInOut),
    );
  }
}
