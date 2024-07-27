import 'package:flutter/material.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';

abstract class ViewRecipeState {}

class FetchRecipeState extends ViewRecipeState {}

class RefreshRecipesState extends ViewRecipeState {
  RefreshRecipesState(this.data, this.animatedListKey);
  GlobalKey<AnimatedListState> animatedListKey;
  final List<RecipeModel> data;
}
