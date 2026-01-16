import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'error_logger.dart';
import '../../core/network/supabase_client.dart';
import '../../core/storage/local_database.dart';

/// Handles app initialization and bootstrap
class AppBootstrap {
  /// Initialize all services before app starts
  static Future<void> initialize() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize error logger first
    ErrorLogger().initialize();
    ErrorLogger().info('Starting app initialization...');

    try {
      // Load environment variables
      await dotenv.load(fileName: '.env');
      // Set preferred orientations
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      // Set system UI overlay style
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      // Initialize Supabase
      await _initializeSupabase();

      // Initialize local database (Drift)
      await _initializeLocalDatabase();

      ErrorLogger().info('App initialization completed successfully');
    } catch (e, stackTrace) {
      ErrorLogger().error('App initialization failed', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize Supabase
  static Future<void> _initializeSupabase() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null) {
      ErrorLogger().warning(
        'Supabase credentials not found in .env file. '
            'Please create a .env file with SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
      // Don't throw in dev - allows UI development without backend
      return;
    }

    await SupabaseClientWrapper.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Initialize local database
  static Future<void> _initializeLocalDatabase() async {
    try {
      // Access database instance to trigger initialization
      final db = LocalDatabase.instance;
      ErrorLogger().info('Local database initialized successfully');

      // Test connection
      await db.select(db.users).get();
    } catch (e, stackTrace) {
      ErrorLogger().error('Failed to initialize local database', e, stackTrace);
      // Don't throw - allow app to work without local storage
    }
  }

  /// Handle global errors
  static void setupErrorHandling() {
    // Catch Flutter framework errors
    FlutterError.onError = (details) {
      ErrorLogger().error(
        'Flutter Error',
        details.exception,
        details.stack,
      );
    };

    // Catch async errors
    PlatformDispatcher.instance.onError = (error, stack) {
      ErrorLogger().error('Async Error', error, stack);
      return true;
    };
  }
}