import 'package:client/models/Recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class RecipeLikeButton extends StatefulWidget {
  final Recipe recipe;
  RecipeLikeButton({required this.recipe});

  @override
  RecipeLikeButtonState createState() => RecipeLikeButtonState();
}

class RecipeLikeButtonState extends State<RecipeLikeButton> {
  @override
  Widget build(BuildContext context) {
    return LikeButton(
        size: 30,
        likeCountAnimationDuration: Duration(milliseconds: 200),
        onTap: (value) {
          return Future.value(!value);
        },
        likeCount: widget.recipe.favorites,
        countBuilder: (count, bool isLiked, String text) {
          var color = isLiked ? Colors.pink : Colors.black;
          return Text(text, style: TextStyle(color: color));
        });
  }
}
