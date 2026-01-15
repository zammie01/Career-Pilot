import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized error logging
class ErrorLogger {
  static final ErrorLogger _instance = ErrorLogger._internal();
  factory ErrorLogger() => _instance;
  ErrorLogger._internal();

  late final Logger _logger;

  void initialize() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
      level: kDebugMode ? Level.debug : Level.warning,
    );
  }

  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);

    // In production, you'd send this to a service like Sentry or Firebase Crashlytics
    if (!kDebugMode) {
      _sendToRemoteLogger(message, error, stackTrace);
    }
  }

  void _sendToRemoteLogger(String message, dynamic error, StackTrace? stackTrace) {
    // TODO: Implement remote logging (Sentry, Firebase, etc.)
    // For now, just a placeholder
  }

  /// Log network requests (useful for debugging)
  void logRequest(String method, String url, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      _logger.d('[$method] $url', error: data);
    }
  }

  /// Log network responses
  void logResponse(int statusCode, String url, {dynamic data}) {
    if (kDebugMode) {
      _logger.d('[$statusCode] $url', error: data);
    }
  }
}