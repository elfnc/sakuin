import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'database/database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

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

  // Force onboarding during development, otherwise use stored setting
  final initialRoute = kDebugMode ? '/onboarding' : (isOnboardingCompleted ? '/home' : '/onboarding');
  container.read(initialRouteProvider.notifier).setRoute(initialRoute);

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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Force light mode to prevent text blending with background in dark mode
      routerConfig: router,
    );
  }
}

