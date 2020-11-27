import 'package:flutter/material.dart';

import './recipes.model.dart';
import './recipes.repository.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  final _biggerFont = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Rezepte")),
        body: FutureBuilder<List<Recipe>>(
          future: RecipesRepository().allRecipes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Recipe> data = snapshot.data;
              return _buildRecipesList(data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }

  Widget _buildRecipesList(List<Recipe> recipes) {
    recipes.sort((recipe1, recipe2) => recipe1.name.compareTo(recipe2.name));
    return Scrollbar(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: recipes.length,
            separatorBuilder: (BuildContext context, int i) => Divider(
                  height: 2,
                  color: Colors.blue,
                ),
            itemBuilder: (context, i) {
              return _buildRow(recipes[i]);
            }));
  }

  Widget _buildRow(Recipe recipe) {
    String subtitle = "";
    final hasSeason = recipe.season != null;
    if (hasSeason) {
      subtitle += recipe.season.name;
    }

    if (recipe.cookBook != null) {
      if (hasSeason) {
        subtitle += " - ";
      }
      subtitle += recipe.cookBook.name;
      if (recipe.cookBook.pageNumber != null) {
        subtitle += " (S. ${recipe.cookBook.pageNumber})";
      }
    }
    return ListTile(
        title: Text(recipe.name, style: _biggerFont),
        subtitle: Text(subtitle),
        dense: true);
  }
}
