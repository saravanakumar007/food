import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodrecipe/core/constants/app_consts.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/pages/detail_view_recipe_page.dart';

void main() {
  group('Detail View Recipe Screen ', () {
    final RecipeModel recipeModelData = RecipeModel(
      image: kDefaultRecipes[0]['image'],
      category: kDefaultRecipes[0]['category'],
      title: kDefaultRecipes[0]['title'],
      ingredients: kDefaultRecipes[0]['ingredients'],
      preparationSteps: kDefaultRecipes[0]['preparationSteps'],
    );
    testWidgets('Verify default Widget Rendering - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        DetailViewRecipePage(
          recipeModel: recipeModelData,
        ),
      );

      expect(find.byType(Image), findsOneWidget);

      expect(find.byType(Text), findsNWidgets(4));

      expect(find.widgetWithText(Text, 'Ingredients'), findsOneWidget);

      expect(find.widgetWithText(Text, 'Preparation Steps'), findsOneWidget);
    });
  });
}
