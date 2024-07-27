import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/presentation/bloc/add_or_edit_recipe_bloc/add_or_edit_recipe_state.dart';

class AddOREditRecipeBloc extends Cubit<AddOrEditRecipeState> {
  AddOREditRecipeBloc() : super(AddRecipeSate());

  Future<void> addRecipe() async {}

  Future<void> updateRecipe() async {}
}
