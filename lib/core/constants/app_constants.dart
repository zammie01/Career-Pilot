/// Application-wide constants
class AppConstants {
  // Prevents instantiation
  AppConstants._();

  // App Info
  static const String appName = 'Career Pilot';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String userIdKey = 'user_id';
  static const String authTokenKey = 'auth_token';
  static const String onboardingCompleteKey = 'onboarding_complete';

  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // UI
  static const double defaultPadding = 25.0;
  static const double defaultBorderRadius = 12.0;

  // Database
  static const String databaseName = 'skillmatch_local.db';
  static const int databaseVersion = 1;
}

/// Environment configuration
enum Environment {
  development,
  staging,
  production;

  bool get isDevelopment => this == Environment.development;
  bool get isProduction => this == Environment.production;
}