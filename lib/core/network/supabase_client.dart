import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/bootstrap/error_logger.dart';

/// Supabase client wrapper
/// This makes it easy to swap to custom backend later
class SupabaseClientWrapper {
  static SupabaseClient? _instance;
  static final _logger = ErrorLogger();

  /// Initialize Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        debug: kDebugMode,
      );

      _instance = Supabase.instance.client;
      _logger.info('Supabase initialized successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to initialize Supabase', e, stackTrace);
      rethrow;
    }
  }

  /// Get Supabase client instance
  static SupabaseClient get client {
    if (_instance == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// Quick access to auth
  static GoTrueClient get auth => client.auth;

  /// Quick access to database
  static SupabaseClient get db => client;


  /// Quick access to storage
  static SupabaseStorageClient get storage => client.storage;

  /// Check if user is authenticated
  static bool get isAuthenticated => auth.currentSession != null;

  /// Get current user
  static User? get currentUser => auth.currentUser;

  /// Get current user ID
  static String? get currentUserId => currentUser?.id;
}

/// Extension for easier access
extension SupabaseX on SupabaseClient {
  SupabaseQueryBuilder table(String tableName) => from(tableName);
}
