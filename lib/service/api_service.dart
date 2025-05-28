import 'dart:convert';
import 'package:expense_tracker/model/category.dart';
import 'package:expense_tracker/utils/app_const.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(AppConst.categoryUrl));

    if (response.statusCode == 200) {
      try {
        final responseBody = json.decode(response.body);
        final dataList = responseBody['expenseCategories'] as List;
        return dataList.map((e) => Category.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }
}
