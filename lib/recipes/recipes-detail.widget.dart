import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipes.model.dart';

class RecipesDetail extends StatelessWidget {
  final Recipe _recipe;
  RecipesDetail(this._recipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(_recipe.name),
        ));
  }
}
