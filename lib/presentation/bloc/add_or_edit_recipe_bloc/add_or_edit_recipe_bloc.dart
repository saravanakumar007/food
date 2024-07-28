import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/domain/repository/recipe_repository.dart';
import 'package:foodrecipe/presentation/bloc/add_or_edit_recipe_bloc/add_or_edit_recipe_state.dart';

class AddOrEditRecipeBloc extends Cubit<AddOrEditRecipeState> {
  final RecipeRepository recipeRepository;
  AddOrEditRecipeBloc({required this.recipeRepository})
      : super(GetRecipeSate());

  Future<void> getRecipes() async {
    final List<List<dynamic>> recipesAndJsonData =
        await recipeRepository.getRecipesAndJsonDataFromLocal();

    emit(
      LoadedRecipeSate(
        recipeItems: recipesAndJsonData[0] as List<RecipeModel>,
        jsonRecipeData: recipesAndJsonData[1],
      ),
    );
  }
}
