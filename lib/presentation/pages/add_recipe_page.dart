// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodrecipe/app/app_colors.dart';
import 'package:foodrecipe/data/models/category_model.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrEditRecipePage extends StatefulWidget {
  const AddOrEditRecipePage({
    super.key,
    this.recipeModel,
    this.isEdit = false,
  });

  final RecipeModel? recipeModel;

  final bool isEdit;

  @override
  State<AddOrEditRecipePage> createState() => _AddOrEditRecipePageState();
}

class _AddOrEditRecipePageState extends State<AddOrEditRecipePage> {
  bool isSubmitClicked = false;
  List<RecipeModel> recipeItems = [];
  List<dynamic> jsonRecipeData = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController ingredientsTextEditingController =
      TextEditingController();
  TextEditingController preparationStepsTextEditingController =
      TextEditingController();
  CategoryModel? dropdownValue;

  @override
  void initState() {
    super.initState();
    populateData();

    if (widget.isEdit) {
      dropdownValue = categories
          .where((element) => element.name == widget.recipeModel!.category)
          .toList()
          .first;
      titleTextEditingController =
          TextEditingController(text: widget.recipeModel!.title);
      ingredientsTextEditingController =
          TextEditingController(text: widget.recipeModel!.ingredients);
      preparationStepsTextEditingController =
          TextEditingController(text: widget.recipeModel!.preparationSteps);
    }
  }

  Future<void> populateData() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    final String? localRecipeData = sharedPref.getString('recipe_data');
    jsonRecipeData =
        jsonDecode((localRecipeData ?? '').isEmpty ? '[]' : localRecipeData!);
    recipeItems = jsonRecipeData.map((e) => RecipeModel.fromJson(e)).toList();
  }

  Future<void> processData() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      if (dropdownValue == null) {
        setState(() {});
        return;
      }
      final SharedPreferences sharedPref =
          await SharedPreferences.getInstance();
      final dynamic currentData = {
        'image': dropdownValue!.image,
        'category': dropdownValue!.name,
        'title': titleTextEditingController.text,
        'ingredients': ingredientsTextEditingController.text,
        'preparationSteps': preparationStepsTextEditingController.text
      };
      if (widget.isEdit) {
        final int currentIndex = jsonRecipeData.indexWhere(
            (element) => element['title'] == widget.recipeModel!.title);
        jsonRecipeData[currentIndex] = currentData;
      } else {
        jsonRecipeData.add(currentData);
      }

      final bool isCompleted =
          await sharedPref.setString('recipe_data', jsonEncode(jsonRecipeData));
      if (isCompleted) {
        Fluttertoast.showToast(
          msg: widget.isEdit ? "Recipe Updated" : "Recipe Added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.kPrimaryColor,
        );
        Navigator.pop(context);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.kPrimaryColor, width: 1),
      borderRadius: BorderRadius.circular(16),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        title: Text(widget.isEdit ? 'Edit Recipe' : 'Add Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CategoryModel>(
                        value: dropdownValue,
                        isExpanded: true,
                        hint: Text(
                          'Select Category',
                          style: TextStyle(
                            color: AppColors.kPrimaryColor,
                          ),
                        ),
                        elevation: 16,
                        onChanged: (CategoryModel? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: categories.map<DropdownMenuItem<CategoryModel>>(
                            (CategoryModel value) {
                          return DropdownMenuItem<CategoryModel>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/images/category/${value.image}",
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 50,
                                    ),
                                  ),
                                  title: Text(value.name.toString()),
                                ),
                              ));
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (dropdownValue == null && isSubmitClicked) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10),
                    child: Text(
                      'Please select a category',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleTextEditingController,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some title';
                    }
                    if (recipeItems.isNotEmpty && !widget.isEdit) {
                      final List<RecipeModel> duplicateTitles = recipeItems
                          .where((element) =>
                              element.title!.trim() == value.trim())
                          .toList();
                      if (duplicateTitles.isNotEmpty) {
                        return 'Please provide unique recipe title';
                      }
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: AppColors.kPrimaryColor),
                    errorStyle:
                        const TextStyle(fontSize: 12, color: Colors.red),
                    enabledBorder: border,
                    focusedBorder: border,
                    border: border,
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: ingredientsTextEditingController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some ingredients';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: AppColors.kPrimaryColor),
                    errorStyle:
                        const TextStyle(fontSize: 12, color: Colors.red),
                    hintText: 'Enter the ingredients',
                    enabledBorder: border,
                    focusedBorder: border,
                    border: border,
                    labelText: 'Ingredients',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: preparationStepsTextEditingController,
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some preparations';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: AppColors.kPrimaryColor),
                    errorStyle:
                        const TextStyle(fontSize: 12, color: Colors.red),
                    enabledBorder: border,
                    focusedBorder: border,
                    border: border,
                    hintText: 'Enter the preparations',
                    labelText: 'Preparation Steps',
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.kPrimaryColor,
                    ),
                    onPressed: () {
                      isSubmitClicked = true;

                      processData();
                    },
                    child: const Text('Submit', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
