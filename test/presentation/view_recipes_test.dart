import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodrecipe/core/constants/app_consts.dart';
import 'package:foodrecipe/presentation/pages/view_recipe_page.dart';
import 'package:foodrecipe/presentation/widgets/home/filter_widget.dart';
import 'package:foodrecipe/presentation/widgets/home/recipe_item.dart';

void main() {
  group('View Recipes Screen ', () {
    testWidgets('Verify default Widget Rendering - Test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      expect(find.byKey(const ValueKey('add_button')), findsOneWidget);

      expect(find.byKey(const ValueKey('popup_menu')), findsOneWidget);

      expect(find.widgetWithText(Text, 'Food Recipes'), findsOneWidget);

      expect(find.byType(FilterWidget), findsOneWidget);
    });

    testWidgets('Verify Default Data - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      // Ensure default recipes

      expect(find.byType(RecipeItem), findsNWidgets(5));

      for (int i = 0; i < kDefaultRecipes.length; i++) {
        Finder keyFinder = find.byKey(
          ValueKey(
            kDefaultRecipes[i]['title']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '_'),
          ),
        );
        expect(keyFinder, findsOneWidget);
      }
    });

    testWidgets('Verify Search behaviour - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      expect(find.byType(RecipeItem), findsNWidgets(5));

      Finder searchFinder = find.byKey(const ValueKey('search_text'));

      await tester.tap(searchFinder);

      await tester.pumpAndSettle();

      await tester.enterText(searchFinder, 'baked eggs');

      // Ensure search recipes

      expect(find.byType(RecipeItem), findsOneWidget);
    });

    testWidgets('Verify Delete recipe - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      expect(find.byType(RecipeItem), findsNWidgets(5));

      Finder searchFinder = find.byKey(const ValueKey('search_text'));

      await tester.tap(searchFinder);

      await tester.pumpAndSettle();

      await tester.enterText(searchFinder, 'baked eggs');

      await tester.pumpAndSettle();

      // Ensure search recipes

      expect(find.byType(RecipeItem), findsOneWidget);

      Finder popupMenuFinder =
          find.byKey(const ValueKey('current_recipe_popup_menu_button'));

      await tester.tap(popupMenuFinder);

      await tester.pumpAndSettle();

      Finder deleteFinder =
          find.byKey(const ValueKey('current_recipe_popup_menu_button'));

      await tester.tap(deleteFinder);

      await tester.pumpAndSettle();

      // Ensure delete recipes

      expect(find.byType(RecipeItem), findsNothing);
    });

    testWidgets('Verify Remove All  - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      expect(find.byType(RecipeItem), findsNWidgets(5));

      Finder popupMenuFinder = find.byKey(const ValueKey('popup_menu'));

      await tester.tap(popupMenuFinder);

      await tester.pumpAndSettle();

      Finder removeAllFinder = find.byKey(const ValueKey('remove_all'));

      await tester.tap(removeAllFinder);

      await tester.pumpAndSettle();

      // Ensure remove all recipes

      expect(find.byType(RecipeItem), findsNothing);
    });

    testWidgets('Verify Filter Widget - Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ViewRecipePage());

      Finder filterFinder = find.byType(FilterWidget);

      await tester.tap(filterFinder);

      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      expect(find.widgetWithText(Text, 'Select Category'), findsOneWidget);

      // Ensure the checkbox widgets rendering
      expect(CheckboxListTile,
          findsNWidgets(CommonCheckboxData.checkboxCategories.length));

      for (int i = 0; i < CommonCheckboxData.checkboxCategories.length; i++) {
        Finder checkBoxFinder = find.byKey(
          ValueKey(
            CommonCheckboxData.checkboxCategories[i]['name']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '_'),
          ),
        );
        expect(checkBoxFinder, findsOneWidget);

        await tester.tap(checkBoxFinder);

        await tester.pumpAndSettle();
      }

      Finder okButtonFinder = find.byKey(const ValueKey('ok_button'));

      await tester.tap(okButtonFinder);

      await tester.pumpAndSettle();

      for (int i = 0; i < CommonCheckboxData.checkboxCategories.length; i++) {
        Finder filterFinder = find.widgetWithText(
            Text, CommonCheckboxData.checkboxCategories[i]['name']);
        expect(filterFinder, findsOneWidget);
      }
    });
  });
}
