import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:drift/drift.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/supabase_client.dart';
import '../../../../core/storage/local_database.dart';
import '../../../../app/bootstrap/error_logger.dart';
import '../../domain/repositories/auth_repository.dart';

/// Supabase implementation of AuthRepository
class SupabaseAuthRepository implements AuthRepository {
  final _logger = ErrorLogger();
  final _db = LocalDatabase.instance;

  @override
  supabase.User? get currentUser => SupabaseClientWrapper.currentUser;

  @override
  bool get isAuthenticated => SupabaseClientWrapper.isAuthenticated;

  @override
  Stream<supabase.AuthState> get authStateChanges =>
      SupabaseClientWrapper.auth.onAuthStateChange;

  @override
  Future<(supabase.User?, Failure?)> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _logger.info('Attempting sign up for: $email');

      // 1. Sign up with Supabase
      final response = await SupabaseClientWrapper.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        return (null, const AuthFailure(message: 'Sign up failed'));
      }

      // 2. Store user locally
      await _storeUserLocally(response.user!, name);

      _logger.info('Sign up successful for: $email');
      return (response.user, null);
    } on supabase.AuthException catch (e) {
      _logger.error('Auth error during sign up', e);
      return (null, AuthFailure(message: e.message, code: e.statusCode));
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during sign up', e, stackTrace);
      return (null, UnknownFailure(message: 'Sign up failed', error: e));
    }
  }

  @override
  Future<(supabase.User?, Failure?)> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _logger.info('Attempting sign in for: $email');

      // 1. Sign in with Supabase
      final response = await SupabaseClientWrapper.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return (null, const AuthFailure(message: 'Sign in failed'));
      }

      // 2. Sync user data locally
      await _syncUserData(response.user!);

      _logger.info('Sign in successful for: $email');
      return (response.user, null);
    } on supabase.AuthException catch (e) {
      _logger.error('Auth error during sign in', e);
      return (null, AuthFailure(message: e.message, code: e.statusCode));
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during sign in', e, stackTrace);
      return (null, UnknownFailure(message: 'Sign in failed', error: e));
    }
  }

  @override
  Future<Failure?> signOut() async {
    try {
      _logger.info('Attempting sign out');

      // 1. Sign out from Supabase
      await SupabaseClientWrapper.auth.signOut();

      // 2. Clear local data
      await _db.clearAllData();

      _logger.info('Sign out successful');
      return null;
    } on supabase.AuthException catch (e) {
      _logger.error('Auth error during sign out', e);
      return AuthFailure(message: e.message, code: e.statusCode);
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during sign out', e, stackTrace);
      return UnknownFailure(message: 'Sign out failed', error: e);
    }
  }

  @override
  Future<Failure?> resetPassword(String email) async {
    try {
      _logger.info('Sending password reset email to: $email');

      await SupabaseClientWrapper.auth.resetPasswordForEmail(email);

      _logger.info('Password reset email sent');
      return null;
    } on supabase.AuthException catch (e) {
      _logger.error('Auth error during password reset', e);
      return AuthFailure(message: e.message, code: e.statusCode);
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during password reset', e, stackTrace);
      return UnknownFailure(message: 'Password reset failed', error: e);
    }
  }

  /// Store user in local database after sign up
  Future<void> _storeUserLocally(supabase.User user, String name) async {
    try {
      await _db.upsertUser(
        UsersCompanion(
          supabaseId: Value(user.id),
          email: Value(user.email ?? ''),
          name: Value(name),
        ),
      );

      _logger.info('User stored locally: ${user.email}');
    } catch (e) {
      _logger.error('Error storing user locally', e);
      // Don't throw - allow auth to succeed even if local storage fails
    }
  }

  /// Sync user data from Supabase to local database
  Future<void> _syncUserData(supabase.User user) async {
    try {
      final name = user.userMetadata?['name'] as String? ?? '';

      await _db.upsertUser(
        UsersCompanion(
          supabaseId: Value(user.id),
          email: Value(user.email ?? ''),
          name: Value(name),
        ),
      );

      _logger.info('User data synced locally: ${user.email}');
    } catch (e) {
      _logger.error('Error syncing user data', e);
      // Don't throw - allow sign in to succeed
    }
  }
}