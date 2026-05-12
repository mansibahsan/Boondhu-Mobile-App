import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/router/app_router.dart';

void main() {
  // ProviderScope is required for Riverpod (your app's brain)
  runApp(const ProviderScope(child: BoondhuApp()));
}

class BoondhuApp extends StatelessWidget {
  const BoondhuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Boondhu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // GoRouter now handles all navigation
      routerConfig: AppRouter.router,
    );
  }
}
