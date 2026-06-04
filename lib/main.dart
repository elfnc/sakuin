import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SakuinApp(),
    ),
  );
}

class SakuinApp extends StatelessWidget {
  const SakuinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakuin',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Will adapt to system by default
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to Sakuin!'),
        ),
      ),
    );
  }
}
