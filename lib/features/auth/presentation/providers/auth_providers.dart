import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/supabase_auth_repository.dart';
import '../../../../core/storage/local_database.dart';
part 'auth_providers.g.dart';
/// Auth repository provider
@riverpod
AuthRepository authRepository(Ref ref) {
  return SupabaseAuthRepository();
}
/// Current user provider (from Supabase)
@riverpod
Stream<supabase.User?> authState(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges.map((state) => state.session?.user);
}
/// Is authenticated provider
@riverpod
Future<bool> isAuthenticated(Ref ref) async {
  final user = await ref.watch(authStateProvider.future);
  return user != null;
}
/// Current user ID provider
@riverpod
String? currentUserId(Ref ref) {
  final authStateValue = ref.watch(authStateProvider);
  return authStateValue.whenOrNull(
    data: (user) => user?.id,
  );
}
// Manual providers for Drift types (riverpod_generator can't handle them)
/// Local user data provider (from Drift database)
final localUserProvider = FutureProvider<User?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  final database = LocalDatabase.instance;
  return await database.getUserBySupabaseId(userId);
});
/// User profile provider (from Drift database)
final userProfileProvider = FutureProvider<Profile?>((ref) async {
  final localUserData = await ref.watch(localUserProvider.future);
  if (localUserData == null) return null;
  final database = LocalDatabase.instance;
  return await database.getUserProfile(localUserData.id);
});