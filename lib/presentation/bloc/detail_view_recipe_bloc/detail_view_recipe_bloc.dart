import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/presentation/bloc/detail_view_recipe_bloc/detail_view_recipe_state.dart';

class DetailViewRecipeBloc extends Cubit<DetailViewRecipeState> {
  DetailViewRecipeBloc() : super(PopulateDataState());

  Future<void> fetchRecipes() async {}
}
