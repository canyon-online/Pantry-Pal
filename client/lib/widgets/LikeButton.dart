import 'package:client/models/Recipe.dart';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

class RecipeLikeButton extends StatefulWidget {
  final Recipe recipe;
  RecipeLikeButton({required this.recipe});

  @override
  RecipeLikeButtonState createState() => RecipeLikeButtonState();
}

class RecipeLikeButtonState extends State<RecipeLikeButton> {
  late int likeCount = 0;
  late String token;
  late bool isLiked;

  void initState() {
    super.initState();
    likeCount = widget.recipe.favorites;
    isLiked = widget.recipe.isLiked;
  }

  Future<bool> _toggleLike(String token, bool value) async {
    Map<String, dynamic> response =
        await API().doLikeRecipe(token, widget.recipe.recipeId);
    print(response);
    setState(() {
      likeCount = response['numFavorites'];
      isLiked = !value;
    });

    return Future.value(isLiked);
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<UserProvider>(context).user.token;
    return LikeButton(
        size: 30,
        likeCountAnimationDuration: Duration(milliseconds: 200),
        onTap: (value) {
          return _toggleLike(token, value);
        },
        isLiked: isLiked,
        likeCount: likeCount,
        countBuilder: (count, bool isLiked, String text) {
          var color = isLiked ? Colors.pink : Colors.black;
          return Text(text, style: TextStyle(color: color));
        });
  }
}
