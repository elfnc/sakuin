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
import 'package:sakuin/features/savings/presentation/screens/add_saving_goal_screen.dart';
import 'package:sakuin/features/ocr/presentation/screens/ocr_scanner_screen.dart';

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

CustomTransitionPage _buildTabTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
  );
}

CustomTransitionPage _buildBottomUpTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

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
            pageBuilder: (context, state) => _buildTabTransition(state, const HomeScreen()),
          ),
          GoRoute(
            path: '/history',
            pageBuilder: (context, state) => _buildTabTransition(state, const HistoryScreen()),
          ),
          GoRoute(
            path: '/savings',
            pageBuilder: (context, state) => _buildTabTransition(state, const SavingsScreen()),
          ),
          GoRoute(
            path: '/insights',
            pageBuilder: (context, state) => _buildTabTransition(state, const InsightsScreen()),
          ),
        ],
      ),
      GoRoute(
        path: '/add-transaction',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'expense';
          return _buildBottomUpTransition(state, AddTransactionScreen(initialType: type));
        },
      ),
      GoRoute(
        path: '/add-savings-goal',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildBottomUpTransition(state, const AddSavingGoalScreen()),
      ),
      GoRoute(
        path: '/ocr-scan',
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) => _buildBottomUpTransition(state, const OcrScannerScreen()),
      ),
    ],
  );
});
