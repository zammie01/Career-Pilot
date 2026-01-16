import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_storage.g.dart';

const _kHasSeenWelcomeKey = 'has_seen_welcome';

@riverpod
class OnboardingStorage extends _$OnboardingStorage {
  late SharedPreferences _prefs;

  @override
  Future<bool> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool(_kHasSeenWelcomeKey) ?? false;
  }

  Future<void> markWelcomeAsSeen() async {
    await _prefs.setBool(_kHasSeenWelcomeKey, true);
    ref.invalidateSelf(); // or ref.notifyListeners() if not using riverpod_annotation
  }

  Future<void> resetOnboarding() async { // useful for testing/logout
    await _prefs.remove(_kHasSeenWelcomeKey);
    ref.invalidateSelf();
  }
}