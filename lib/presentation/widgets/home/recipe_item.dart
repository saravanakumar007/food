import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodrecipe/core/resources/app_colors.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/pages/add_or_edit_recipe_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

var defaultData = [
  {
    "category": "",
    "title": "",
    "ingredients": [
      "8 cups sliced fresh or frozen peaches, thawed",
      "½ cup white sugar",
      "cooking spray",
      "1 (15.25 ounce) package white cake mix",
      "½ cup butter, cut into 8 pieces",
    ],
    "preparationSteps": [
      "Combine peaches and sugar in a medium bowl. Stir well and let stand for 5 minutes.",
      "Liberally spray a slow cooker with cooking spray",
      "Stir peaches once more and add to the prepared slow cooker. Sprinkle cake mix evenly over the peaches; don't stir. Distribute butter pieces evenly over cake mix",
      "Cover and cook on High until cake is golden and bubbly around the edges, about 3½ hours. Turn off slow cooker and let stand 15 minutes before serving",
    ]
  }
];

class RecipeItem extends StatelessWidget {
  const RecipeItem({
    super.key,
    required this.listKey,
    required this.recipeModel,
    required this.refreshCallback,
    required this.recipeItems,
  });

  final GlobalKey<AnimatedListState> listKey;

  final VoidCallback refreshCallback;

  final List<RecipeModel> recipeItems;

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.kPrimaryColor.withOpacity(0.3),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/placeholder.png',
                height: 80,
                width: 80,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/recipe_title.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            '${recipeModel.title}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/category/${recipeModel.image!}",
                        fit: BoxFit.fill,
                        height: 18,
                        width: 20,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '${recipeModel.category}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
                key: const ValueKey('current_recipe_popup_menu_button'),
                constraints: const BoxConstraints(maxWidth: 125),
                onSelected: (index) {
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AddOrEditRecipePage(
                          isEdit: true,
                          recipeModel: recipeModel,
                        ),
                      ),
                    ).then((value) {
                      refreshCallback();
                    });
                  } else if (index == 1) {
                    deleteItem(context);
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.kPrimaryColor,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      key: const ValueKey('edit_recipe'),
                      value: 0,
                      height: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: AppColors.kPrimaryColor),
                          const SizedBox(width: 5),
                          Text(
                            'Edit',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: AppColors.kPrimaryColor),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      key: const ValueKey('delete_recipe'),
                      value: 1,
                      height: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.kPrimaryColor),
                          const SizedBox(width: 10),
                          Text(
                            'Delete',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: AppColors.kPrimaryColor),
                          ),
                        ],
                      ),
                    )
                  ];
                })
          ],
        ),
      ),
    );
  }

  Future<void> deleteItem(BuildContext context) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final String? localRecipeData = sharedPref.getString('recipe_data');
    final List<dynamic> jsonRecipeData = jsonDecode(localRecipeData ?? '[]');
    final int currentIndex = jsonRecipeData
        .indexWhere((element) => element['title'] == recipeModel.title);
    jsonRecipeData.removeAt(currentIndex);
    final bool isDeleted =
        await sharedPref.setString('recipe_data', jsonEncode(jsonRecipeData));
    if (isDeleted) {
      recipeItems.removeAt(currentIndex);

      listKey.currentState!.removeItem(currentIndex, (context, animation) {
        animation.addStatusListener(
          (status) {
            if (animation.status == AnimationStatus.dismissed) {
              refreshCallback();
            }
          },
        );
        return SizeTransition(
          sizeFactor: animation,
          child: RecipeItem(
            listKey: listKey,
            recipeItems: recipeItems,
            recipeModel: recipeModel,
            refreshCallback: refreshCallback,
          ),
        );
      });
      Fluttertoast.showToast(
        msg: "Recipe Deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.kPrimaryColor,
      );
    }
  }
}
