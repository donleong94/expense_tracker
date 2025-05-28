import 'package:expense_tracker/bloc/category/category_event.dart';
import 'package:expense_tracker/bloc/category/category_state.dart';
import 'package:expense_tracker/repository/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError('Failed to load categories'));
      }
    });
  }
}
