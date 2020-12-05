import 'package:flutter/material.dart';
import 'package:receptor/recipes/recipe-item.widget.dart';
import 'package:receptor/recipes/recipe-setter.widget.dart';
import 'package:receptor/recipes/recipes-detail.widget.dart';

import 'recipes.model.dart';
import 'recipes.repository.dart';

class RecipesList extends StatefulWidget {
  @override
  _RecipesListState createState() => _RecipesListState();
}

class Search extends SearchDelegate {
  List<Recipe> _recipes;
  Recipe selectedResult;
  Search(this._recipes) : super(searchFieldLabel: "Suchen");
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(child: Center(child: Text(selectedResult.name)));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Recipe> suggestions = [];
    if (query.isNotEmpty) {
      suggestions.addAll(_recipes.where((element) =>
          element.name.toLowerCase().contains(query.toLowerCase()) ||
          element.tags
              .any((t) => t.toLowerCase().contains(query.toLowerCase()))));
    }
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return RecipeItem(suggestions[index]);
      },
    );
  }
}

class _RecipesListState extends State<RecipesList> {
  List<Recipe> _recipes;

  @override
  void initState() {
    super.initState();
    RecipesRepository()
        .allRecipes(false)
        .then((rs) => setState(() => _recipes = rs));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rezepte"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search(_recipes));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: _buildRecipesList(),
        onRefresh: () async {
          var recipes = await RecipesRepository().allRecipes(true);
          setState(() => _recipes = recipes);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  RecipeSetter(Recipe(name: "", tags: [], cookBook: null))));
          if (result is Recipe) {
            await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RecipesDetail(result)));
            _recipes = await RecipesRepository().allRecipes(false);
            setState(() {});
          }
        },
      ),
    );
  }

  Widget _buildRecipesList() {
    if (_recipes == null) return LinearProgressIndicator();
    _recipes.sort((recipe1, recipe2) => recipe1.name.compareTo(recipe2.name));
    return Scrollbar(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            itemCount: _recipes.length,
            separatorBuilder: (BuildContext context, int i) => Divider(),
            itemBuilder: (context, i) {
              return RecipeItem(_recipes[i]);
            }));
  }
}
