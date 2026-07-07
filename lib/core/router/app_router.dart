import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/calendar/calendar_screen.dart';
import '../../features/chat/presentation/chat_detail_screen.dart';
import '../../features/components/components_screen.dart';
import '../../features/courier/domain/courier_models.dart';
import '../../features/courier/presentation/courier_screen.dart';
import '../../features/courier/presentation/tracking_screen.dart';
import '../../features/email/presentation/compose_screen.dart';
import '../../features/email/presentation/email_detail_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/settings/currency_screen.dart';
import '../../features/settings/faq_screen.dart';
import '../../features/settings/two_factor_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wallet/presentation/wallet_screen.dart';
import '../widgets/root_shell.dart';

/// App navigation. Launch starts at `/splash` (animated brand reveal), which
/// routes to `/onboarding` on first run or the `/` bottom-nav shell (Home, Chat,
/// Email, Charts, Settings) otherwise; detail screens are pushed on top so back
/// navigation just works.
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/', builder: (context, state) => const RootShell()),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) =>
          ChatDetailScreen(threadId: state.pathParameters['id']!),
    ),
    // Keep /email/compose before /email/:id so it is not captured as an id.
    GoRoute(
      path: '/email/compose',
      builder: (context, state) => const ComposeScreen(),
    ),
    GoRoute(
      path: '/email/:id',
      builder: (context, state) =>
          EmailDetailScreen(emailId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/components',
      builder: (context, state) => const ComponentsScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    // Keep /courier/tracking before /courier so it is matched first.
    GoRoute(
      path: '/courier/tracking',
      builder: (context, state) {
        final shipment = state.extra;
        if (shipment is! Shipment) {
          return const Scaffold(
            body: Center(child: Text('Tiada penghantaran dipilih')),
          );
        }
        return TrackingScreen(shipment: shipment);
      },
    ),
    GoRoute(
      path: '/courier',
      builder: (context, state) => const CourierScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/settings/currency',
      builder: (context, state) => const CurrencyScreen(),
    ),
    GoRoute(
      path: '/settings/2fa',
      builder: (context, state) => const TwoFactorScreen(),
    ),
    GoRoute(
      path: '/settings/faq',
      builder: (context, state) => const FaqScreen(),
    ),
  ],
);
