import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:sakuin/features/onboarding/presentation/screens/profile_setup_screen.dart';
import 'package:sakuin/features/home/presentation/screens/home_screen.dart';
import 'package:sakuin/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:sakuin/features/transaction/presentation/screens/history_screen.dart';
import 'package:sakuin/features/savings/presentation/screens/savings_screen.dart';
import 'package:sakuin/features/insight/presentation/screens/insights_screen.dart';
import 'package:sakuin/features/transaction/presentation/screens/add_transaction_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class InitialRouteNotifier extends Notifier<String> {
  @override
  String build() => '/onboarding';

  void setRoute(String route) {
    state = route;
  }
}

final initialRouteProvider = NotifierProvider<InitialRouteNotifier, String>(InitialRouteNotifier.new);

final routerProvider = Provider<GoRouter>((ref) {
  final initialRoute = ref.watch(initialRouteProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/savings',
            builder: (context, state) => const SavingsScreen(),
          ),
          GoRoute(
            path: '/insights',
            builder: (context, state) => const InsightsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'expense';
          return AddTransactionScreen(initialType: type);
        },
      ),
    ],
  );
});
