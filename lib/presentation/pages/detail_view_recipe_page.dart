import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/core/resources/app_colors.dart';
import 'package:foodrecipe/data/models/recipe_model.dart';
import 'package:foodrecipe/presentation/bloc/detail_view_recipe_bloc/detail_view_recipe_bloc.dart';
import 'package:foodrecipe/presentation/bloc/detail_view_recipe_bloc/detail_view_recipe_state.dart';

class DetailViewRecipePage extends StatefulWidget {
  const DetailViewRecipePage({
    super.key,
    required this.recipeModel,
  });

  final RecipeModel recipeModel;

  @override
  State<DetailViewRecipePage> createState() => _DetailViewRecipePageState();
}

class _DetailViewRecipePageState extends State<DetailViewRecipePage> {
  String ingredients = '', preparationSteps = '';

  @override
  void initState() {
    super.initState();
    LineSplitter lineSplitter = const LineSplitter();
    List<String> lineSplitterContents =
        lineSplitter.convert(widget.recipeModel.ingredients!);
    List<String> splitContents = widget.recipeModel.ingredients!.split(',');
    final List<String> ingredientsContents =
        lineSplitterContents.length > splitContents.length
            ? lineSplitterContents
            : splitContents;
    int i = 0;
    for (String line in ingredientsContents) {
      if (line.isNotEmpty) {
        i += 1;
        ingredients += '$i. $line\n\n';
      }
    }

    lineSplitterContents =
        lineSplitter.convert(widget.recipeModel.preparationSteps!);
    splitContents = widget.recipeModel.preparationSteps!.split('.');
    final List<String> preparationStepsContents =
        lineSplitterContents.length > splitContents.length
            ? lineSplitterContents
            : splitContents;
    i = 0;
    for (String line in preparationStepsContents) {
      if (line.isNotEmpty) {
        i += 1;
        preparationSteps += '$i. $line\n\n';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailViewRecipeBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          title: Text(widget.recipeModel.title.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<DetailViewRecipeBloc, DetailViewRecipeState>(
            builder: (context, state) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '(${widget.recipeModel.category!})',
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        Image.asset(
                          'assets/images/ingredients.png',
                          fit: BoxFit.cover,
                          height: 145,
                          width: 150,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 21,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ingredients,
                          style: const TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: AppColors.cardColor,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/cooking.png',
                              fit: BoxFit.cover,
                              height: 145,
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Preparation Steps',
                              style: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              preparationSteps,
                              style: const TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
