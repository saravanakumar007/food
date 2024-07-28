import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodrecipe/presentation/pages/add_or_edit_recipe_page.dart';
import 'package:foodrecipe/presentation/pages/view_recipe_page.dart';

void main() {
  group('Add Recipe Screen ', () {
    testWidgets('Verify default Widget Rendering - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AddOrEditRecipePage());

      expect(find.byType(DropdownButton), findsNWidgets(1));

      expect(find.byKey(const ValueKey('select_category')), findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(3));

      expect(find.byKey(const ValueKey('title_textfield')), findsOneWidget);

      expect(
          find.byKey(const ValueKey('ingredients_textfield')), findsOneWidget);

      expect(find.byKey(const ValueKey('preparation_steps_textfield')),
          findsOneWidget);

      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('Verify Category Validation - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      Finder titleFinder = find.byKey(const ValueKey('title_textfield'));
      Finder ingredientsFinder =
          find.byKey(const ValueKey('ingredients_textfield'));

      Finder preparationStepsFinder =
          find.byKey(const ValueKey('preparation_steps_textfield'));

      expect(titleFinder, findsOneWidget);
      expect(ingredientsFinder, findsOneWidget);
      expect(preparationStepsFinder, findsOneWidget);

      await tester.tap(titleFinder);

      await tester.pumpAndSettle();

      await tester.enterText(titleFinder, 'Fruit Juice');

      await tester.pumpAndSettle();

      await tester.tap(ingredientsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(ingredientsFinder,
          '2 x 400g cans cherry tomatoes,400g can mixed bean salad, drained 200g baby spinach,4 medium eggs,50g thinly sliced smoked ham, torn wholemeal rye bread');

      await tester.pumpAndSettle();

      await tester.tap(preparationStepsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(preparationStepsFinder,
          'Tip the tomatoes and bean salad into an ovenproof frying pan or shallow flameproof casserole dish. Simmer for 10 mins, or until reduced. Stir in the spinach and cook for 5 mins more until wilted.Heat the grill to medium. Make four indentations in the mixture using the back of a spoon, then crack one egg in each. Nestle the ham in the mixture, then grill for 4-5 mins, or until the whites are set and the yolks runny. Serve with rye bread, if you like.');

      await tester.pumpAndSettle();

      Finder submitFinder = find.byKey(const ValueKey('submit_button'));

      await tester.tap(submitFinder);

      await tester.pumpAndSettle();

      expect(find.widgetWithText(Text, 'Please select a category'),
          findsOneWidget);
    });

    testWidgets('Verify Title Validation - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      Finder ingredientsFinder =
          find.byKey(const ValueKey('ingredients_textfield'));

      Finder preparationStepsFinder =
          find.byKey(const ValueKey('preparation_steps_textfield'));

      expect(ingredientsFinder, findsOneWidget);
      expect(preparationStepsFinder, findsOneWidget);

      await tester.tap(ingredientsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(ingredientsFinder,
          '2 x 400g cans cherry tomatoes,400g can mixed bean salad, drained 200g baby spinach,4 medium eggs,50g thinly sliced smoked ham, torn wholemeal rye bread');

      await tester.pumpAndSettle();

      await tester.tap(preparationStepsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(preparationStepsFinder,
          'Tip the tomatoes and bean salad into an ovenproof frying pan or shallow flameproof casserole dish. Simmer for 10 mins, or until reduced. Stir in the spinach and cook for 5 mins more until wilted.Heat the grill to medium. Make four indentations in the mixture using the back of a spoon, then crack one egg in each. Nestle the ham in the mixture, then grill for 4-5 mins, or until the whites are set and the yolks runny. Serve with rye bread, if you like.');

      await tester.pumpAndSettle();

      Finder submitFinder = find.byKey(const ValueKey('submit_button'));

      await tester.tap(submitFinder);

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(Text, 'Please enter some title'), findsOneWidget);
    });

    testWidgets('Verify Ingredients Validation - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      Finder titleFinder = find.byKey(const ValueKey('title_textfield'));

      Finder preparationStepsFinder =
          find.byKey(const ValueKey('preparation_steps_textfield'));

      expect(titleFinder, findsOneWidget);

      expect(preparationStepsFinder, findsOneWidget);

      await tester.tap(titleFinder);

      await tester.pumpAndSettle();

      await tester.enterText(titleFinder, 'Fruit Juice');

      await tester.pumpAndSettle();

      await tester.tap(preparationStepsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(preparationStepsFinder,
          'Tip the tomatoes and bean salad into an ovenproof frying pan or shallow flameproof casserole dish. Simmer for 10 mins, or until reduced. Stir in the spinach and cook for 5 mins more until wilted.Heat the grill to medium. Make four indentations in the mixture using the back of a spoon, then crack one egg in each. Nestle the ham in the mixture, then grill for 4-5 mins, or until the whites are set and the yolks runny. Serve with rye bread, if you like.');

      await tester.pumpAndSettle();

      Finder submitFinder = find.byKey(const ValueKey('submit_button'));

      await tester.tap(submitFinder);

      await tester.pumpAndSettle();

      expect(find.widgetWithText(Text, 'Please enter some ingredients'),
          findsOneWidget);
    });

    testWidgets('Verify Preparation Steps Validation - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      Finder titleFinder = find.byKey(const ValueKey('title_textfield'));
      Finder ingredientsFinder =
          find.byKey(const ValueKey('ingredients_textfield'));

      expect(titleFinder, findsOneWidget);
      expect(ingredientsFinder, findsOneWidget);

      await tester.tap(titleFinder);

      await tester.pumpAndSettle();

      await tester.enterText(titleFinder, 'Fruit Juice');

      await tester.pumpAndSettle();

      await tester.tap(ingredientsFinder);

      await tester.pumpAndSettle();

      await tester.enterText(ingredientsFinder,
          '2 x 400g cans cherry tomatoes,400g can mixed bean salad, drained 200g baby spinach,4 medium eggs,50g thinly sliced smoked ham, torn wholemeal rye bread');

      await tester.pumpAndSettle();

      Finder submitFinder = find.byKey(const ValueKey('submit_button'));

      await tester.tap(submitFinder);

      await tester.pumpAndSettle();

      expect(find.widgetWithText(Text, 'Please enter some preparations'),
          findsOneWidget);
    });
  });
}
