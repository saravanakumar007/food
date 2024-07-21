import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodrecipe/app/app_colors.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/pages/add_recipe_page.dart';
import 'package:foodrecipe/presentation/pages/detail_view_reccipe_page.dart';
import 'package:foodrecipe/presentation/widgets/home/filter_widget.dart';
import 'package:foodrecipe/presentation/widgets/home/recipe_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

var defaultData = [
  {
    'category': 'Appetiser',
    'image': 'appetiser.jpeg',
    'title': 'Smoked mackerel & leek hash with horseradish',
    'ingredients':
        '250g new potatoes, halved 2 tbsp oil, 2 large leeks, thinly sliced,100g peppered smoked mackerel, skin removed,4 eggs,2 tbsp creamed horseradish, optional',
    'preparationSteps':
        "Put the potatoes in a microwaveable bowl with a splash of water, cover, then cook on high for 5 mins until tender (or steam or simmer them).Meanwhile, heat the oil in a frying pan over a medium heat, add the leeks with a pinch of salt and cook for 10 mins, stirring so they don’t stick, until softened. Tip in the potatoes, turn up the heat and fry for a couple of mins to crisp them up a bit. Flake through the mackerel.Make four indents in the leek mixture in the pan, crack an egg into each, season, then cover the pan and cook for 6-8 mins until the whites have set and the yolks are runny. Serve the horseradish on the side, with the pan in the middle of the table."
  },
  {
    'category': 'Beans Recipe',
    'image': 'beans.jpeg',
    'title': 'Saucy bean baked eggs',
    'ingredients':
        '2 x 400g cans cherry tomatoes,400g can mixed bean salad, drained 200g baby spinach,4 medium eggs,50g thinly sliced smoked ham, torn wholemeal rye bread',
    'preparationSteps':
        "Tip the tomatoes and bean salad into an ovenproof frying pan or shallow flameproof casserole dish. Simmer for 10 mins, or until reduced. Stir in the spinach and cook for 5 mins more until wilted.Heat the grill to medium. Make four indentations in the mixture using the back of a spoon, then crack one egg in each. Nestle the ham in the mixture, then grill for 4-5 mins, or until the whites are set and the yolks runny. Serve with rye bread, if you like."
  },
  {
    'category': 'Cake',
    'image': 'cake.jpeg',
    'title': 'Vegan strawberry pancakes',
    'ingredients':
        '115g wholemeal spelt flour,1 tsp baking powder,1 tsp cinnamon,150ml soya milk,240g soya yogurt,1 tsp vanilla extract,drop of rapeseed oil,200g strawberries, hulled and halved or quartered if large,2 tbsp chopped pecans,a few small mint leaves,',
    'preparationSteps':
        "Mix the flour with the baking powder and cinnamon in a bowl using a balloon whisk. In a jug, whisk together the soya milk, 2 tbsp of the yogurt and vanilla extract, then whisk this into the dry ingredients to make a thick batter.Rub the oil around the pan using kitchen paper, then set the pan over a medium heat. Spoon in 1½ tbsp batter in three or four places to make small pancakes. Cook over a low heat for 1-2 mins until set, and bubbles appear on the surface, then turn the pancakes using a palette knife. Cook for another 1-2 mins until golden and cooked through. Repeat with the remaining batter to make six pancakes in total.Serve three pancakes per person topped with the remaining yogurt, berries, pecans and mint leaves."
  },
  {
    'category': 'Bbq',
    'image': 'bbq.jpeg',
    'title': 'Healthy BBQ chicken',
    'ingredients':
        '4 skinless chicken breast fillets (about 760g),125g passata,1 medjool date, stoned,2 garlic cloves,1 tbsp balsamic vinegar,1tsp smoked paprika,½tsp mustard powder,1 tsp olive oil, plus extra if frying,4 jacket potatoes',
    'preparationSteps':
        "Put the chicken fillets in a food bag or between two sheets of baking parchment, and bash lightly with a rolling pin until they are an even thickness – avoid making them too thin. Put in a large shallow dish.Pour the passata into a large bowl along with the date, garlic, balsamic, paprika, mustard powder and oil. Blitz using a hand blender until smooth, then pour over the chicken, turning it several times to ensure it’s well coated. Cook straightaway as directed below, or cover and chill to marinate overnight.Cook the chicken on a barbecue over ashen coals for 6-7 mins on each side, or fry in a non-stick pan over a medium-high heat with a drizzle oil for 6-7 mins each side until cooked through. Toss the salad ingredients together in a bowl and serve with the chicken and jacket potatoes, if you like."
  },
  {
    'category': 'Coffee',
    'image': 'coffee.jpeg',
    'title': 'Iced coffee recipes',
    'ingredients': '200ml strong black coffee,50ml milk,ice,maple syrup',
    'preparationSteps':
        "Make a 200ml cup of black coffee following pack instructions, then allow the coffee to go completely cold. Pour into a blender with the milk along with 2 or 3 handfuls of ice and maple syrup, if using, then blend until smooth and foamy.Pour into a chilled tall glass and serve."
  }
];

class ViewRecipePage extends StatefulWidget {
  const ViewRecipePage({super.key});

  @override
  State<ViewRecipePage> createState() => _ViewRecipePageState();
}

class _ViewRecipePageState extends State<ViewRecipePage> {
  List<RecipeModel> recipeItems = [];
  List<dynamic> filterByCategories = [];
  final TextEditingController searchTextEditingController =
      TextEditingController();
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    recipeItems.clear();
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final bool? setDefaultData = sharedPref.getBool('set_recipe_default_data');
    if (!(setDefaultData ?? false)) {
      final bool isCompleted =
          await sharedPref.setString('recipe_data', jsonEncode(defaultData));
      if (isCompleted) {
        await sharedPref.setBool('set_recipe_default_data', true);
      }
    }
    final String? localRecipeData = sharedPref.getString('recipe_data');
    final List<dynamic> jsonRecipeData =
        jsonDecode((localRecipeData ?? '').isEmpty ? '[]' : localRecipeData!);
    recipeItems = jsonRecipeData.map((e) => RecipeModel.fromJson(e)).toList();
    applyFilter();
  }

  void filter(List<dynamic> categories) {
    filterByCategories = categories;
    applyFilter();
  }

  void applyFilter() {
    for (var item in recipeItems) {
      bool shown = false;
      if (filterByCategories.isNotEmpty) {
        final int categoryIndex = filterByCategories.indexWhere((filterItem) =>
            filterItem['name'].toString().toLowerCase() ==
            item.category!.toLowerCase());
        if (categoryIndex > -1) {
          shown = true;
        }
      } else {
        shown = true;
      }
      if (shown) {
        shown = item.title!
            .trim()
            .toLowerCase()
            .contains(searchTextEditingController.text.toLowerCase());
      }
      item.shown = shown;
    }
    setState(() {
      _listKey = GlobalKey<AnimatedListState>();
    });
  }

  Future<void> removeAllItems() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final bool isCompleted = await sharedPref.setString('recipe_data', "");
    if (isCompleted) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 1),
      borderRadius: BorderRadius.circular(16),
    );
    bool isNotEmpty = recipeItems.any((element) => element.shown ?? false);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.kPrimaryColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.kPrimaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AddOrEditRecipePage(),
              ),
            ).then((value) {
              fetchData();
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          title: const Text('Food Recipes'),
          centerTitle: false,
          actions: [
            PopupMenuButton(
                constraints: const BoxConstraints(maxWidth: 150),
                onSelected: (index) {
                  if (index == 0) {
                    removeAllItems();
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      height: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: AppColors.kPrimaryColor),
                          const SizedBox(width: 5),
                          Text(
                            'Remove All',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: AppColors.kPrimaryColor),
                          ),
                        ],
                      ),
                    )
                  ];
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FilterWidget(
                      key: GlobalKey(),
                      recipeItems: recipeItems,
                      onFilter: filter,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      //  padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            color: AppColors.kPrimaryColor,
                          )
                        ],
                      ),
                      child: TextField(
                        controller: searchTextEditingController,
                        cursorColor: AppColors.kPrimaryColor,
                        onChanged: (value) {
                          applyFilter();
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              searchTextEditingController.clear();
                              applyFilter();
                            },
                            child: Icon(
                              Icons.clear,
                              color: AppColors.kPrimaryColor,
                            ),
                          ),
                          hintText: 'Search by Title',
                          enabledBorder: border,
                          focusedBorder: border,
                          border: border,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 5,
                spacing: 5,
                direction: Axis.horizontal,
                children: [
                  ...List.generate(
                    filterByCategories.length,
                    (index) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                              color: AppColors.kPrimaryColor.withOpacity(0.3),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    filterByCategories[index]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    final int categoryIndex = CommonCheckboxData
                                        .checkboxCategories
                                        .indexWhere((element) =>
                                            element['name'] ==
                                            filterByCategories[index]['name']);
                                    CommonCheckboxData
                                            .checkboxCategories[categoryIndex]
                                        ['value'] = CommonCheckboxData
                                            .checkboxCategories[categoryIndex]
                                        ['selected'] = false;

                                    filterByCategories.removeAt(index);
                                    applyFilter();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.kPrimaryColor
                                          .withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 15,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).toList(),
                ],
              ),
              Expanded(
                child: isNotEmpty
                    ? AnimatedList(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        key: _listKey,
                        initialItemCount: recipeItems.length,
                        itemBuilder: _buildItem,
                      )
                    : Center(
                        child: Text(
                          'There is no recipes',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return (recipeItems[index].shown ?? true)
        ? SizeTransition(
            sizeFactor: animation,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DetailViewRecipePage(
                      recipeModel: recipeItems[index],
                    ),
                  ),
                ).then((value) {
                  fetchData();
                });
              },
              child: RecipeItem(
                listKey: _listKey,
                recipeItems: recipeItems,
                recipeModel: recipeItems[index],
                refreshCallback: fetchData,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
