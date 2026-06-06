import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sakuin/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:sakuin/features/home/presentation/screens/home_screen.dart';

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
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
