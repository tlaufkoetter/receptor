import 'package:flutter/cupertino.dart';
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
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text("Suchen"),
              onPressed: () async =>
                  showSearch(context: context, delegate: Search(_recipes))),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text("Hinzufügen"),
            onPressed: () async {
              final result =
                  await Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => RecipeSetter(Recipe(tags: [])),
              ));
              if (result is Recipe) {
                _recipes = await RecipesRepository().allRecipes(false);
                setState(() {});
                await Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => RecipesDetail(result)));
              }
            },
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            _recipes = await RecipesRepository().allRecipes(true);
            setState(() {});
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(_listBuilder),
              )),
        )
      ],
    );
  }

  BorderRadius _getClip(int index) {
    if (index == 0) return BorderRadius.vertical(top: Radius.circular(10));
    if (index == _recipes.length - 1)
      return BorderRadius.vertical(bottom: Radius.circular(10));
    return BorderRadius.zero;
  }

  Widget _listBuilder(BuildContext context, int index) {
    if (_recipes == null) return Center(child: CupertinoActivityIndicator());
    if (index ~/ 2 >= _recipes.length) return null;
    if (index % 2 == 1)
      return Divider(
        height: 0,
      );

    return ClipRRect(
        borderRadius: _getClip(index ~/ 2),
        child: RecipeItem(_recipes[index ~/ 2]));
  }
}
