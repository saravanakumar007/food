import 'package:flutter/material.dart';
import 'package:foodrecipe/core/resources/app_colors.dart';
import 'package:foodrecipe/data/models/category_model.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';

class ActionButton {
  ActionButton({
    this.key,
    required this.text,
    this.onPressed,
    this.isPrimaryButton = true,
  });
  final Key? key;
  final String text;
  final bool isPrimaryButton;
  final Function()? onPressed;

  Widget getWidget() {
    return TextButton(
      key: key,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor:
            isPrimaryButton ? AppColors.kPrimaryColor : Colors.white,
        side: BorderSide(
          color: AppColors.kPrimaryColor,
        ),
      ),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        }
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: isPrimaryButton ? Colors.white : AppColors.kPrimaryColor,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class CommonCheckboxData {
  static final List<dynamic> checkboxCategories = [];
}

class FilterWidget extends StatefulWidget {
  const FilterWidget({
    super.key,
    required this.onFilter,
    required this.recipeItems,
  });

  final Function onFilter;

  final List<RecipeModel> recipeItems;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  CategoryModel? dropdownValue;

  @override
  void initState() {
    super.initState();
    populateData();
  }

  void populateData() {
    if (CommonCheckboxData.checkboxCategories.isEmpty) {
      for (int i = 0; i < categories.length; i++) {
        CommonCheckboxData.checkboxCategories.add(
          {
            'selected': false,
            'value': false,
            'name': categories[i].name,
            'image': categories[i].image,
          },
        );
      }
    }
  }

  void showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          CommonCheckboxData.checkboxCategories.length,
                          (index) => StatefulBuilder(
                            builder: (context, checkboxState) =>
                                CheckboxListTile(
                              key: ValueKey(
                                CommonCheckboxData.checkboxCategories[index]
                                        ['name']
                                    .toString()
                                    .toLowerCase()
                                    .replaceAll(' ', '_'),
                              ),
                              activeColor: AppColors.kPrimaryColor,
                              value: CommonCheckboxData
                                  .checkboxCategories[index]['selected'],
                              secondary: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/images/category/${CommonCheckboxData.checkboxCategories[index]['image']}",
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              title: Text(CommonCheckboxData
                                  .checkboxCategories[index]['name']),
                              onChanged: (bool? value) {
                                checkboxState(() {
                                  CommonCheckboxData.checkboxCategories[index]
                                      ['selected'] = value;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ActionButton(
                      key: const ValueKey('cancel_button'),
                      text: 'Cancel',
                      onPressed: () {
                        for (int i = 0;
                            i < CommonCheckboxData.checkboxCategories.length;
                            i++) {
                          CommonCheckboxData.checkboxCategories[i]['selected'] =
                              CommonCheckboxData.checkboxCategories[i]['value'];
                        }
                        Navigator.pop(context);
                      },
                    ).getWidget(),
                    const SizedBox(width: 20),
                    ActionButton(
                      key: const ValueKey('ok_button'),
                      text: 'Ok',
                      onPressed: () {
                        for (int i = 0;
                            i < CommonCheckboxData.checkboxCategories.length;
                            i++) {
                          CommonCheckboxData.checkboxCategories[i]['value'] =
                              CommonCheckboxData.checkboxCategories[i]
                                  ['selected'];
                        }
                        List<dynamic> currentSelectedCategories =
                            CommonCheckboxData.checkboxCategories
                                .where((element) => element['value'])
                                .toList();
                        widget.onFilter(currentSelectedCategories);
                        Navigator.pop(context);
                      },
                    ).getWidget(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < CommonCheckboxData.checkboxCategories.length; i++) {
          CommonCheckboxData.checkboxCategories[i]['selected'] =
              CommonCheckboxData.checkboxCategories[i]['value'];
        }
        showCategoryDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 1),
              spreadRadius: 1,
              blurRadius: 5,
              color: AppColors.kPrimaryColor,
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_outlined,
              color: AppColors.kPrimaryColor,
            ),
            const Text('Filter By Category'),
          ],
        ),
      ),
    );
  }
}
