import 'package:expense_tracker/core_component/user_preferences.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/repository/category_repository.dart';
import 'package:expense_tracker/service/api_service.dart';
import 'package:expense_tracker/utils/app_const.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final getIt = GetIt.instance;

/// Global singleton initialization
Future<void> startup() async {
  // Initialize Hive
  var path = (await getApplicationDocumentsDirectory()).path;
  Hive.init(path);
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>(AppConst.hiveExpenseKey);

  // Initialize UserPreferences
  final userPreferences = UserPreferences();
  await userPreferences.init();
  getIt.registerSingleton<UserPreferences>(userPreferences);

  // Initialize ApiService
  getIt.registerSingleton<ApiService>(ApiService());
  getIt.registerSingleton<CategoryRepository>(CategoryRepository(getIt()));
}
