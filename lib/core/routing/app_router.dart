import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../storage/onboarding_storage.dart';

part 'app_router.g.dart';

/// Helper class to refresh router when auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Welcome screen
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Sign up screen
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const SignUpScreen(),
      ),

      // Sign in screen
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const SignInScreen(),
      ),

      // Home screen (protected)
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
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

    // Redirect logic based on auth state
    redirect: (context, state) async {
      final authAsync = ref.read(authStateProvider);
      final hasSeenWelcome = await ref.read(onboardingStorageProvider.future);

      // 1. While auth is loading → stay on splash (return null = proceed to current route)
      if (authAsync.isLoading) {
        return null;
      }

      final user = authAsync.value;           // safe because !isLoading
      final isLoggedIn = user != null;
      final currentPath = state.matchedLocation;

      // 2. Logged-in users always go to home (protect all other screens)
      if (isLoggedIn) {
        if (currentPath != AppRoutes.home) {
          return AppRoutes.home;
        }
        return null;
      }

      // 3. Not logged in → decide between welcome or login
      if (!hasSeenWelcome) {
        // First time → welcome (also allow staying if already there)
        if (currentPath != AppRoutes.welcome) {
          return AppRoutes.welcome;
        }
      } else {
        // Returning user → login
        if (currentPath != AppRoutes.login) {
          return AppRoutes.login;
        }
      }

      // Allow register or other public flows if needed
      return null;
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