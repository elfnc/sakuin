import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'database/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final db = container.read(databaseProvider);

  // Initialize DB and fetch settings
  bool isOnboardingCompleted = false;
  try {
    final settings = await db.select(db.appSettings).getSingleOrNull();
    if (settings != null) {
      isOnboardingCompleted = settings.isOnboardingCompleted;
    }
  } catch (_) {
    // First run or DB not ready
  }

  container.read(initialRouteProvider.notifier).setRoute(isOnboardingCompleted ? '/home' : '/onboarding');

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SakuinApp(),
    ),
  );
}

class SakuinApp extends ConsumerWidget {
  const SakuinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Sakuin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Will adapt to system by default
      routerConfig: router,
    );
  }
}

