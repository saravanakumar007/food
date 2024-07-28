abstract class DetailViewRecipeState {}

class GetDataState extends DetailViewRecipeState {}

class LoadedDataState extends DetailViewRecipeState {
  LoadedDataState({required this.ingredients, required this.preparationSteps});
  final String ingredients;
  final String preparationSteps;
}
