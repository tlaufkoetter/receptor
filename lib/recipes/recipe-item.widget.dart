import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipes-detail.widget.dart';
import 'package:receptor/recipes/recipes.model.dart';

class RecipeItem extends StatelessWidget {
  final Recipe _recipe;
  RecipeItem(this._recipe);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String subtitle = "";
    if (_recipe.cookBook != null) {
      subtitle += _recipe.cookBook.name;
      if (_recipe.cookBook.pageNumber != null) {
        subtitle += " (S. ${_recipe.cookBook.pageNumber})";
      }
    }
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      tileColor: theme.canvasColor,
      title: Text(
        _recipe.name,
      ),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      dense: true,
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecipesDetail(_recipe)));
      },
    );
  }
}
