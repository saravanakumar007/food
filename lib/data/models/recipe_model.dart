class RecipeModel {
  String? category;
  String? title;
  String? ingredients;
  String? preparationSteps;
  String? image;
  bool? shown;

  RecipeModel({
    this.category,
    this.title,
    this.ingredients,
    this.preparationSteps,
    this.image,
    this.shown = true,
  });

  RecipeModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    title = json['title'];
    ingredients = json['ingredients'];
    preparationSteps = json['preparationSteps'];
    image = json['image'];
    shown = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['title'] = title;
    data['ingredients'] = ingredients;
    data['preparationSteps'] = preparationSteps;
    data['image'] = image;
    data['shown'] = shown;
    return data;
  }
}
