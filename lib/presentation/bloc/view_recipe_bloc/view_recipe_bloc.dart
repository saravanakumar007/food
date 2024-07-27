import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/domain/repository/recipe_repository.dart';
import 'package:foodrecipe/presentation/bloc/view_recipe_bloc/view_recipe_state.dart';

class ViewRecipeBloc extends Cubit<ViewRecipeState> {
  final RecipeRepository recipeRepository;
  ViewRecipeBloc(this.recipeRepository) : super(FetchRecipeState());

  Future<void> fetchRecipes(
      List<dynamic> filterByCategories, String searchText) async {
    final List<RecipeModel> recipes = await recipeRepository.getRecipes();
    applyFilter(recipes, filterByCategories, searchText);
  }

  void applyFilter(List<RecipeModel> recipeItems,
      List<dynamic> filterByCategories, String searchText) {
    for (var item in recipeItems) {
      bool shown = false;
      if (filterByCategories.isNotEmpty) {
        final int categoryIndex = filterByCategories.indexWhere((filterItem) =>
            filterItem['name'].toString().toLowerCase() ==
            item.category!.toLowerCase());
        if (categoryIndex > -1) {
          shown = true;
        }
      } else {
        shown = true;
      }
      if (shown) {
        shown =
            item.title!.trim().toLowerCase().contains(searchText.toLowerCase());
      }
      item.shown = shown;
    }
    emit(RefreshRecipesState(recipeItems, GlobalKey<AnimatedListState>()));
  }
}
