import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/core/resources/app_colors.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/bloc/view_recipe_bloc/view_recipe_bloc.dart';
import 'package:foodrecipe/presentation/bloc/view_recipe_bloc/view_recipe_state.dart';
import 'package:foodrecipe/presentation/pages/add_or_edit_recipe_page.dart';
import 'package:foodrecipe/presentation/pages/detail_view_recipe_page.dart';
import 'package:foodrecipe/presentation/widgets/home/filter_widget.dart';
import 'package:foodrecipe/presentation/widgets/home/recipe_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewRecipePage extends StatefulWidget {
  const ViewRecipePage({super.key});

  @override
  State<ViewRecipePage> createState() => _ViewRecipePageState();
}

class _ViewRecipePageState extends State<ViewRecipePage> {
  List<RecipeModel> recipeItems = [];
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  List<dynamic> filterByCategories = [];
  final TextEditingController searchTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ViewRecipeBloc>(context)
        .fetchRecipes(filterByCategories, searchTextEditingController.text);
  }

  void filter(List<dynamic> categories) {
    filterByCategories = categories;
    BlocProvider.of<ViewRecipeBloc>(context)
        .fetchRecipes(filterByCategories, searchTextEditingController.text);
  }

  Future<void> removeAllItems() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final bool isCompleted = await sharedPref.setString('recipe_data', "");
    if (isCompleted) {
      BlocProvider.of<ViewRecipeBloc>(context)
          .fetchRecipes(filterByCategories, searchTextEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 1),
      borderRadius: BorderRadius.circular(16),
    );

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
              icon: Icon(Icons.settings),
              label: 'Settings',
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          key: const ValueKey('add_button'),
          backgroundColor: AppColors.kPrimaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const AddOrEditRecipePage(),
              ),
            ).then((value) {
              BlocProvider.of<ViewRecipeBloc>(context).fetchRecipes(
                  filterByCategories, searchTextEditingController.text);
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          title: const Text('Food Recipes'),
          centerTitle: false,
          actions: [
            PopupMenuButton(
                key: const ValueKey('popup_menu'),
                constraints: const BoxConstraints(maxWidth: 160),
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
                      key: const ValueKey('remove_all'),
                      value: 0,
                      height: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
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
        body: BlocBuilder<ViewRecipeBloc, ViewRecipeState>(
            builder: (BuildContext context, state) {
          if (state is FetchRecipeState) {
            return const CircularProgressIndicator();
          } else if (state is RefreshRecipesState) {
            recipeItems = state.data;
            animatedListKey = state.animatedListKey;
            bool isNotEmpty =
                state.data.any((element) => element.shown ?? false);
            return Padding(
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
                            recipeItems: state.data,
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
                              key: const ValueKey('search_text'),
                              controller: searchTextEditingController,
                              cursorColor: AppColors.kPrimaryColor,
                              onChanged: (value) {
                                BlocProvider.of<ViewRecipeBloc>(context)
                                    .applyFilter(
                                  state.data,
                                  filterByCategories,
                                  searchTextEditingController.text,
                                );
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    searchTextEditingController.clear();
                                    BlocProvider.of<ViewRecipeBloc>(context)
                                        .applyFilter(
                                      state.data,
                                      filterByCategories,
                                      searchTextEditingController.text,
                                    );
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
                            key: ValueKey(
                              filterByCategories[index]['name']
                                  .toString()
                                  .toLowerCase()
                                  .replaceAll(' ', '_'),
                            ),
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
                                    color: AppColors.kPrimaryColor
                                        .withOpacity(0.3),
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
                                          final int categoryIndex =
                                              CommonCheckboxData
                                                  .checkboxCategories
                                                  .indexWhere((element) =>
                                                      element['name'] ==
                                                      filterByCategories[index]
                                                          ['name']);
                                          CommonCheckboxData.checkboxCategories[
                                                  categoryIndex]['value'] =
                                              CommonCheckboxData
                                                          .checkboxCategories[
                                                      categoryIndex]
                                                  ['selected'] = false;

                                          filterByCategories.removeAt(index);
                                          BlocProvider.of<ViewRecipeBloc>(
                                                  context)
                                              .applyFilter(
                                            state.data,
                                            filterByCategories,
                                            searchTextEditingController.text,
                                          );
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              key: state.animatedListKey,
                              initialItemCount: state.data.length,
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
                ));
          } else {
            return const SizedBox.shrink();
          }
        }),
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
                  BlocProvider.of<ViewRecipeBloc>(context).fetchRecipes(
                    filterByCategories,
                    searchTextEditingController.text,
                  );
                });
              },
              child: RecipeItem(
                key: ValueKey(
                  recipeItems[index].title!.toLowerCase().replaceAll(' ', '_'),
                ),
                listKey: animatedListKey,
                recipeItems: recipeItems,
                recipeModel: recipeItems[index],
                refreshCallback: () {
                  BlocProvider.of<ViewRecipeBloc>(context).fetchRecipes(
                    filterByCategories,
                    searchTextEditingController.text,
                  );
                },
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
