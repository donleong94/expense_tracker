import 'package:shared_preferences/shared_preferences.dart';

/// Used to store general data
class UserPreferences {
  late final SharedPreferencesWithCache prefs;

  // Key
  static const String _totalBudgetKey = 'total_budget';

  Future init() async {
    prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // When an allowlist is included, any keys that aren't included cannot be used.
        // If it is null, all keys can be used.
        allowList: null,
      ),
    );
  }

  // Clear all shared preferences data
  Future<void> clearSharedPreferences() async {
    await prefs.clear();
  }

  // region Get and Set methods

  Future<void> setTotalBudget(double value) async {
    await prefs.setDouble(_totalBudgetKey, value);
  }

  double getTotalBudget() {
    return prefs.getDouble(_totalBudgetKey) ?? 0.0;
  }

  // endregion
}
