import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../onboarding/providers/onboarding_provider.dart';

/// Branded launch screen. Plays the animated Lottie mark over the violet brand
/// gradient, then routes onward: first-time users see the Getting Started flow,
/// returning users go straight to the app shell.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Let the Lottie mark assemble, then hand off to the next screen.
    _timer = Timer(const Duration(milliseconds: 2900), _next);
  }

  void _next() {
    if (!mounted) return;
    final seen = ref.read(onboardingSeenProvider);
    context.go(seen ? '/' : '/onboarding');
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C4DF6), Color(0xFF9B51E0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: Lottie.asset(
                        'assets/lottie/splash.json',
                        fit: BoxFit.contain,
                        repeat: true,
                        // If the Lottie ever fails to decode, still show the mark.
                        errorBuilder: (_, _, _) => Center(
                          child: Image.asset(
                            'assets/branding/logo_mark.png',
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter Foundation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(begin: 0.3, curve: Curves.easeOut),
                    const SizedBox(height: 6),
                    Text(
                      'Modul boleh guna semula, siap pakai',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13.5,
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation(
                            Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 1100.ms, duration: 600.ms),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
