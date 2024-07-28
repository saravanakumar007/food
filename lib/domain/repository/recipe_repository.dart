import 'package:foodrecipe/data/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getRecipesDataFromLocal();

  Future<List<List<dynamic>>> getRecipesAndJsonDataFromLocal();
}
