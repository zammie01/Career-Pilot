import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../../core/errors/failures.dart';

/// Authentication repository interface
/// This abstraction allows us to swap implementations (Supabase → Custom backend)
abstract class AuthRepository {
  /// Get current authenticated user
  supabase.User? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Sign up with email and password
  Future<(supabase.User?, Failure?)> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with email and password
  Future<(supabase.User?, Failure?)> signIn({
    required String email,
    required String password,
  });

  /// Sign out
  Future<Failure?> signOut();

  /// Send password reset email
  Future<Failure?> resetPassword(String email);

  /// Watch auth state changes
  Stream<supabase.AuthState> get authStateChanges;
}