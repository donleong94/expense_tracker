import 'package:expense_tracker/model/category.dart';
import 'package:expense_tracker/service/api_service.dart';

/// Repository for fetching data from the service layer
class CategoryRepository {
  CategoryRepository(this.apiService);

  final ApiService apiService;

  Future<List<Category>> fetchCategories() {
    return apiService.fetchCategories();
  }
}