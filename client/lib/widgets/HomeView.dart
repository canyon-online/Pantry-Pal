import 'package:flutter/material.dart';
import 'Recipe.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => new HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late ScrollController controller;

  List<RecipeCard> items =
      new List.generate(10, (index) => RecipeCard(Recipe.defaultRecipe()));

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
          controller: controller,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
        ),
      ),
    );
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      setState(() {
        items.addAll(
            List.generate(10, (index) => RecipeCard(Recipe.defaultRecipe())));
      });
    }
  }
}
