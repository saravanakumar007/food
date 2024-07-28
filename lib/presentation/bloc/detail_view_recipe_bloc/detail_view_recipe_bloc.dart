import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/bloc/detail_view_recipe_bloc/detail_view_recipe_state.dart';

class DetailViewRecipeBloc extends Cubit<DetailViewRecipeState> {
  DetailViewRecipeBloc() : super(GetDataState());

  void getDetailViewData(RecipeModel recipeModel) {
    String ingredients = '', preparationSteps = '';
    LineSplitter lineSplitter = const LineSplitter();
    List<String> lineSplitterContents =
        lineSplitter.convert(recipeModel.ingredients!);
    List<String> splitContents = recipeModel.ingredients!.split(',');
    final List<String> ingredientsContents =
        lineSplitterContents.length > splitContents.length
            ? lineSplitterContents
            : splitContents;
    int i = 0;
    for (String line in ingredientsContents) {
      if (line.isNotEmpty) {
        i += 1;
        ingredients += '$i. $line\n\n';
      }
    }

    lineSplitterContents = lineSplitter.convert(recipeModel.preparationSteps!);
    splitContents = recipeModel.preparationSteps!.split('.');
    final List<String> preparationStepsContents =
        lineSplitterContents.length > splitContents.length
            ? lineSplitterContents
            : splitContents;
    i = 0;
    for (String line in preparationStepsContents) {
      if (line.isNotEmpty) {
        i += 1;
        preparationSteps += '$i. $line\n\n';
      }
    }
    emit(
      LoadedDataState(
        ingredients: ingredients,
        preparationSteps: preparationSteps,
      ),
    );
  }
}
