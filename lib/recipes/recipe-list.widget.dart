import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receptor/recipes/recipe-item.widget.dart';
import 'package:receptor/recipes/recipe-setter.widget.dart';
import 'package:receptor/recipes/recipes-detail.widget.dart';
import 'package:receptor/shared/lists/sliver-list-pack.widget.dart';

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
      final tokens = query
          .split(" ")
          .where((t) => t.isNotEmpty)
          .map((t) => t.toLowerCase());
      suggestions.addAll(_recipes.where((element) => tokens.any((t) =>
          element.name.toLowerCase().contains(t) ||
          element.tags
              .any((t) => tokens.any((to) => t.toLowerCase().contains(to))))));
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
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<RecipesRepository>();
    repo.allRecipes(false).then((rs) => setState(() => _recipes = rs));

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
            child: Text("Hinzuf??gen"),
            onPressed: () async {
              final result =
                  await Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => RecipeSetter(Recipe(tags: [])),
              ));
              if (result is Recipe) {
                _recipes = await repo.allRecipes(false);
                setState(() {});
                await Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => RecipesDetail(result)));
              }
            },
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            _recipes = await repo.allRecipes(true);
            setState(() {});
          },
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverPadding(
              padding: EdgeInsets.all(15),
              sliver: SliverListPack(
                  _recipes, (context, data) => RecipeItem(data))),
        )
      ],
    );
  }
}
