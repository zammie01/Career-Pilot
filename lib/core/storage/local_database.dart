import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../constants/app_constants.dart';
import '../../app/bootstrap/error_logger.dart';

part 'local_database.g.dart';

/// Users table - stores user profile data
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get supabaseId => text().unique()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Skills table - stores user skills
class Skills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get category => text()(); // e.g., "technical", "soft", "language"
  IntColumn get proficiency => integer()(); // 1-5 scale
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// User profiles - extended user information
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade).unique()();
  TextColumn get bio => text().nullable()();
  TextColumn get currentRole => text().nullable()();
  TextColumn get experience => text().nullable()(); // JSON string
  TextColumn get education => text().nullable()(); // JSON string
  TextColumn get strengths => text().nullable()(); // JSON array
  TextColumn get interests => text().nullable()(); // JSON array
  BoolColumn get onboardingComplete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// CVs table - stores user CV versions
class CVs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get content => text()(); // JSON string with CV data
  TextColumn get targetRole => text().nullable()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Chat messages table - stores AI conversation history
class ChatMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text()(); // "user" or "assistant"
  TextColumn get content => text()();
  TextColumn get sessionId => text()(); // Group messages by conversation
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Local database class
@DriftDatabase(tables: [Users, Skills, Profiles, CVs, ChatMessages])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Singleton pattern
  static LocalDatabase? _instance;
  static LocalDatabase get instance {
    _instance ??= LocalDatabase();
    return _instance!;
  }

  /// Get user by Supabase ID
  Future<User?> getUserBySupabaseId(String supabaseId) async {
    try {
      return await (select(users)
        ..where((u) => u.supabaseId.equals(supabaseId)))
          .getSingleOrNull();
    } catch (e) {
      ErrorLogger().error('Error getting user by Supabase ID', e);
      return null;
    }
  }

  /// Create or update user
  Future<User> upsertUser(UsersCompanion user) async {
    try {
      return await into(users).insertReturning(
        user,
        onConflict: DoUpdate(
              (old) => user.copyWith(
            updatedAt: Value(DateTime.now()),
          ),
        ),
      );
    } catch (e) {
      ErrorLogger().error('Error upserting user', e);
      rethrow;
    }
  }

  /// Get user skills
  Future<List<Skill>> getUserSkills(int userId) async {
    try {
      return await (select(skills)..where((s) => s.userId.equals(userId))).get();
    } catch (e) {
      ErrorLogger().error('Error getting user skills', e);
      return [];
    }
  }

  /// Add skill
  Future<Skill> addSkill(SkillsCompanion skill) async {
    return await into(skills).insertReturning(skill);
  }

  /// Get user profile
  Future<Profile?> getUserProfile(int userId) async {
    try {
      return await (select(profiles)..where((p) => p.userId.equals(userId)))
          .getSingleOrNull();
    } catch (e) {
      ErrorLogger().error('Error getting user profile', e);
      return null;
    }
  }

  /// Upsert user profile
  Future<Profile> upsertProfile(ProfilesCompanion profile) async {
    return await into(profiles).insertReturning(
      profile,
      onConflict: DoUpdate((old) => profile),
    );
  }

  /// Get chat messages for a session
  Stream<List<ChatMessage>> watchChatMessages(int userId, String sessionId) {
    return (select(chatMessages)
      ..where((m) => m.userId.equals(userId) & m.sessionId.equals(sessionId))
      ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  /// Add chat message
  Future<ChatMessage> addChatMessage(ChatMessagesCompanion message) async {
    return await into(chatMessages).insertReturning(message);
  }

  /// Clear all data (useful for logout)
  Future<void> clearAllData() async {
    try {
      await transaction(() async {
        await delete(chatMessages).go();
        await delete(cVs).go();
        await delete(skills).go();
        await delete(profiles).go();
        await delete(users).go();
      });
      ErrorLogger().info('All local data cleared');
    } catch (e) {
      ErrorLogger().error('Error clearing data', e);
      rethrow;
    }
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));

    ErrorLogger().info('Database path: ${file.path}');

    return NativeDatabase.createInBackground(file);
  });
}