import 'dart:convert';

import 'package:foodrecipe/core/constants/app_consts.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/domain/repository/recipe_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  @override
  Future<List<RecipeModel>> getRecipesDataFromLocal() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final bool? setDefaultData = sharedPref.getBool('set_recipe_default_data');
    if (!(setDefaultData ?? false)) {
      final bool isCompleted = await sharedPref.setString(
          'recipe_data', jsonEncode(kDefaultRecipes));
      if (isCompleted) {
        await sharedPref.setBool('set_recipe_default_data', true);
      }
    }
    final String? localRecipeData = sharedPref.getString('recipe_data');
    final List<dynamic> jsonRecipeData =
        jsonDecode((localRecipeData ?? '').isEmpty ? '[]' : localRecipeData!);
    return jsonRecipeData.map((e) => RecipeModel.fromJson(e)).toList();
  }

  @override
  Future<List<List<dynamic>>> getRecipesAndJsonDataFromLocal() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final String? localRecipeData = sharedPref.getString('recipe_data');
    final List<dynamic> jsonRecipeData =
        jsonDecode((localRecipeData ?? '').isEmpty ? '[]' : localRecipeData!);
    final List<RecipeModel> recipeItems =
        jsonRecipeData.map((e) => RecipeModel.fromJson(e)).toList();
    return [recipeItems, jsonRecipeData];
  }
}
