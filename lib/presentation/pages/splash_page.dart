import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodrecipe/core/resources/app_colors.dart';
import 'package:foodrecipe/data/repository/recipe_repository_impl.dart';
import 'package:foodrecipe/presentation/bloc/view_recipe_bloc/view_recipe_bloc.dart';
import 'package:foodrecipe/presentation/pages/view_recipe_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => BlocProvider(
            create: (context) => ViewRecipeBloc(
              RecipeRepositoryImpl(),
            ),
            child: const ViewRecipePage(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kPrimaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          height: 200,
          width: 200,
          key: const ValueKey('splash_image'),
        ),
      ),
    );
  }
}
