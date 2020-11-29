import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipe-item.widget.dart';

import 'recipes.model.dart';
import 'recipes.repository.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListState createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
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
            separatorBuilder: (BuildContext context, int i) => Divider(),
            itemBuilder: (context, i) {
              return RecipeItem(recipes[i]);
            }));
  }
}
