import 'package:client/models/Recipe.dart';
import 'package:client/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';

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
        child: GridView.builder(
          padding: EdgeInsets.fromLTRB(30, 15, 15, 30),
          controller: controller,
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return items[index];
          },
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 391,
              maxCrossAxisExtent: 500,
              mainAxisSpacing: 30,
              crossAxisSpacing: 30,
              childAspectRatio: 391 / 500),
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
