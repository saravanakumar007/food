import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodrecipe/main.dart';
import 'package:foodrecipe/presentation/pages/splash_page.dart';
import 'package:foodrecipe/presentation/pages/view_recipe_page.dart';

import '../utils/utils.dart';

void main() {
  group(' widget rendering - test', () {
    testWidgets('widget rendering - test', (WidgetTester tester) async {
      await tester.pumpWidget(const RecipeApp());
      await tester.pumpUntilFound(tester, find.byType(ViewRecipePage));
      expect(find.byType(SplashPage), findsOneWidget);
      expect(find.byKey(const ValueKey('splash_image')), findsOneWidget);
    });
  });

  group('After Splash screen loaded - test', () async {
    testWidgets('After Splash screen loaded - test',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RecipeApp());
      await tester.pumpUntilFound(tester, find.byType(ViewRecipePage));
      expect(find.widgetWithText(Text, 'Food Recipes'), findsOneWidget);
    });
  });
}
