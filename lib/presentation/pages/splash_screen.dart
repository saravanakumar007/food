import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodrecipe/app/app_colors.dart';
import 'package:foodrecipe/presentation/pages/view_recipe_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const ViewRecipePage(),
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
        ),
      ),
    );
  }
}
