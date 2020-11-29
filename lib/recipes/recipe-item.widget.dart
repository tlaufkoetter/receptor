import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipes-detail.widget.dart';
import 'package:receptor/recipes/recipes.model.dart';

class RecipeItem extends StatelessWidget {
  final Recipe _recipe;
  RecipeItem(this._recipe);
  @override
  Widget build(BuildContext context) {
    String subtitle = "";
    final hasSeason = _recipe.season != null;
    if (hasSeason) {
      subtitle += _recipe.season.name;
    }

    if (_recipe.cookBook != null) {
      if (hasSeason) {
        subtitle += " - ";
      }
      subtitle += _recipe.cookBook.name;
      if (_recipe.cookBook.pageNumber != null) {
        subtitle += " (S. ${_recipe.cookBook.pageNumber})";
      }
    }
    return ListTile(
      title: Text(
        _recipe.name,
      ),
      subtitle: Text(subtitle),
      dense: true,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecipesDetail(_recipe)));
      },
    );
  }
}
