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

  bool _isLoading = false;
  bool _hasMore = true;
  List<Future<Recipe>> recipes = <Future<Recipe>>[];
  int offset = 0;

  @override
  void initState() {
    super.initState();

    _getRecipes(0);

    controller = new ScrollController(initialScrollOffset: 1)
      ..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
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
    );
  }

  void _getRecipes(int offset) async {
    items.addAll(
        List.generate(10, (index) => RecipeCard(Recipe.defaultRecipe())));
    _isLoading = false;
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        _isLoading = true;

        if (_isLoading) {
          offset = offset + 1;
          _getRecipes(offset);
        }
      });
    }
  }
}
