import 'package:foodrecipe/data/models/recipe_model.dart';

abstract class AddOrEditRecipeState {}

class GetRecipeSate extends AddOrEditRecipeState {}

class LoadedRecipeSate extends AddOrEditRecipeState {
  LoadedRecipeSate({required this.jsonRecipeData, required this.recipeItems});
  final List<RecipeModel> recipeItems;
  final List<dynamic> jsonRecipeData;
}

class AddRecipeSate extends AddOrEditRecipeState {}

class EditRecipeSate extends AddOrEditRecipeState {}
