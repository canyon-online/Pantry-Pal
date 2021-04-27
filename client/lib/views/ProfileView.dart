import 'package:pantrypal/models/Recipe.dart';
import 'package:pantrypal/utils/API.dart';
import 'package:pantrypal/utils/UserProvider.dart';
import 'package:pantrypal/widgets/AccountInfo.dart';
import 'package:pantrypal/widgets/RecipeCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final Widget _accountInfo = AccountInfo();
  @override
  ProfileViewState createState() => ProfileViewState();
}

// Creates a state class relating to the addRecipeForm widget
class ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  static const int _pageSize = 1;
  late String _token;
  late TabController _tabController;
  late PagewiseLoadController<Recipe> _pageLoadController;

  @override
  void initState() {
    super.initState();

    _token = Provider.of<UserProvider>(context, listen: false).user.token;
    _pageLoadController = PagewiseLoadController<Recipe>(
        pageFuture: _getRecipes, pageSize: _pageSize);
    _tabController =
        new TabController(initialIndex: _currentIndex, length: 2, vsync: this)
          ..addListener(_tabListener);
  }

  Future<List<Recipe>> _getRecipes(int? page) {
    return _currentIndex == 0
        ? API().getFavoriteRecipes(_token, page! * _pageSize, _pageSize)
        : API().getMyRecipes(_token, page! * _pageSize, _pageSize);
  }

  void _tabListener() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
        _pageLoadController.reset();
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabListener);
    _tabController.dispose();
    _pageLoadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: <Widget>[
        SliverList(
            delegate: SliverChildListDelegate([
          widget._accountInfo,
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: _currentIndex == 0
                    ? Icon(Icons.favorite,
                        color: Theme.of(context).colorScheme.primary)
                    : Icon(
                        Icons.favorite_outline,
                        color: Colors.grey,
                      ),
              ),
              Tab(
                icon: _currentIndex == 1
                    ? Icon(Icons.food_bank,
                        color: Theme.of(context).colorScheme.primary)
                    : Icon(
                        Icons.food_bank_outlined,
                        color: Colors.grey,
                      ),
              )
            ],
          ),
        ])),
        PagewiseSliverGrid<Recipe>.extent(
          maxCrossAxisExtent: 500,
          childAspectRatio: 410 / 391,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
          pageLoadController: _pageLoadController,
          showRetry: false,
          noItemsFoundBuilder: (context) {
            return Text(
                _currentIndex == 0
                    ? 'You have not liked any recipes'
                    : 'You have not created any recipes',
                style: TextStyle(color: Colors.grey.shade700));
          },
          errorBuilder: (context, error) {
            return Text('Error: $error',
                style: TextStyle(color: Colors.grey.shade700));
          },
          itemBuilder: (context, Recipe entry, index) {
            return RecipeCard(entry);
          },
        )
      ],
    );
  }
}
