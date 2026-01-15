import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';

part 'app_router.g.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
}

/// GoRouter provider
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome screen
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // TODO: Add more routes as features are built
      // GoRoute(
      //   path: AppRoutes.onboarding,
      //   builder: (context, state) => const OnboardingScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.login,
      //   builder: (context, state) => const LoginScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.home,
      //   builder: (context, state) => const HomeScreen(),
      // ),
    ],

    // Error screen
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri}',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.splash),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),

    // Redirect logic (e.g., check auth state)
    redirect: (context, state) {
      // TODO: Add auth redirect logic
      // final isAuthenticated = ref.read(authStateProvider);
      // if (!isAuthenticated && state.uri.path == AppRoutes.home) {
      //   return AppRoutes.login;
      // }
      return null; // No redirect
    },
  );
}

/// Extension for type-safe navigation
extension GoRouterX on BuildContext {
  void goToWelcome() => go(AppRoutes.welcome);
  void goToOnboarding() => go(AppRoutes.onboarding);
  void goToLogin() => go(AppRoutes.login);
  void goToHome() => go(AppRoutes.home);
}